# V11 room invitations

## जोड़ा गया
- Authenticated room invitation endpoint
- Firebase Admin multicast notification sender
- Invalid device-token cleanup
- Flutter invite API client
- Notification से room ID खोलने वाला router

## उपयोग से पहले
1. Backend को Firestore और Firebase Messaging access वाला application-default credential दें।
2. Firebase Cloud Messaging API enable रखें।
3. Login के बाद NotificationService और NotificationRouter initialize करें।
4. Invite UI में recipient का Firebase UID इस्तेमाल करें, फोन नंबर या ईमेल को notification payload में न डालें।
5. Production से पहले recipient privacy, block list, invite limits और host authorization जोड़ें।

यह version notification delivery foundation देता है। User search और invite button UI अगला हिस्सा है।
