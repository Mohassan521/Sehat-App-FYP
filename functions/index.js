const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendOrderNotificationUpdated = onDocumentCreated("Orders/{orderId}",
    async (event)=> {
      try {
        const snapshot = event.data;
        if (!snapshot) {
          console.log("No data associated with the event");
          return;
        }

        const newValue = snapshot.data();
        const customerName = newValue.username;
        const orderId = event.params.orderId;

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

        // ✅ Fetch FCM tokens for Admin users only
        const tokensSnapshot = await admin.firestore()
            .collection("registeredUsers")
            .where("role", "==", "Admin") // Correct filtering for admins only
            .get();

        const tokens = tokensSnapshot.docs
            .map((doc) => doc.data().fcmToken)
            .filter((token) => token); // Removes undefined tokens

        if (tokens.length > 0) {
          const response = await admin.messaging().sendEachForMulticast({
            tokens: tokens,
            notification: payload.notification,
          });
          console.log(`Notifications sent: ${response.successCount} success`);
        } else {
          console.log("No valid admin tokens found.");
        }
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });
