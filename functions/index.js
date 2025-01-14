const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendOrderNotification = onDocumentCreated("Orders/{orderId}",
    async (event) => {
      const snapshot = event.data;
      if (!snapshot) {
        console.log("No data associated with the event");
        return;
      }

      const newValue = snapshot.data();
      const customerName = newValue.username; // Adjust to your field name
      const orderId = event.params.orderId; // Corrected parameter access for v2

      const payload = {
        notification: {
          title: "New Order Received!",
          body: `Order ID: ${orderId} from ${customerName}`,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {
          orderId: orderId,
          customerName: customerName,
        },
      };

      // Fetch FCM tokens from Firestore
      try {
        const tokensSnapshot = await admin.firestore()
            .collection("registeredUsers").get();
        const tokens = [];

        // Loop through each document in the registeredUsers collection
        tokensSnapshot.forEach((doc) => {
          if (doc.exists) {
            const userData = doc.data();
            const token = userData.fcmToken;
            const role = userData.role; // Assuming you are storing the user

            // Check if the user is an admin and has a valid token
            if (role === "Admin" && token) {
              tokens.push(token);
            }
          }
        });

        if (tokens.length > 0) {
          const response = await admin.messaging().sendEachForMulticast({
            tokens,
            ...payload, // Ensure your payload is defined outside correctl
          });
          console.log(`Notifications sent: ${response.successCount} success`);
          console.log("Admin tokens:", tokens);
        } else {
          console.log("No valid admin tokens found");
        }
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });
