# V12 user search, invite UI, and blocking

- Profile save now stores `displayNameLower` for prefix search.
- Search sheet finds up to 20 users by normalized name prefix.
- Host can send a room invitation from the sheet.
- Users can block and unblock another UID.
- Backend verifies that only the room host can invite.
- Backend refuses an invitation when the recipient has blocked the host.

Deploy `firestore.rules.v12` after review. Existing users need a one-time migration to populate `displayNameLower`.
For advanced full-text search, Firestore's documented text-search feature requires a Firestore Enterprise edition database and text indexes.
