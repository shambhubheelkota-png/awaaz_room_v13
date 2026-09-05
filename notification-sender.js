const admin = require('firebase-admin');

async function getUserTokens(userId) {
  const snapshot = await admin.firestore()
    .collection('users').doc(userId).collection('devices').get();
  return snapshot.docs.map((doc) => doc.data().token).filter(Boolean);
}

async function sendRoomInvite({ recipientId, roomId, roomTitle, inviterName }) {
  const tokens = await getUserTokens(recipientId);
  if (!tokens.length) return { successCount: 0, failureCount: 0 };

  const response = await admin.messaging().sendEachForMulticast({
    tokens,
    notification: {
      title: `${inviterName} ने आपको बुलाया`,
      body: roomTitle,
    },
    data: {
      type: 'room_invite',
      roomId,
    },
    android: { priority: 'high' },
    apns: { payload: { aps: { sound: 'default' } } },
  });

  const invalid = [];
  response.responses.forEach((result, index) => {
    const code = result.error?.code;
    if (code === 'messaging/invalid-registration-token' ||
        code === 'messaging/registration-token-not-registered') {
      invalid.push(tokens[index]);
    }
  });
  await Promise.all(invalid.map((token) => admin.firestore()
    .collection('users').doc(recipientId).collection('devices').doc(token).delete()));
  return { successCount: response.successCount, failureCount: response.failureCount };
}

module.exports = { sendRoomInvite };
