const {onDocumentCreated,
  onDocumentUpdated}=require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.updatedOrdersNotifications = onDocumentCreated("Orders/{orderId}",
    async (event) => {
      try {
        const snapshot = event.data;
        if (!snapshot) {
          console.log("No data associated with the event");
          return;
        }

        const newValue = snapshot.data();
        const orderId = event.params.orderId;
        const customerName = newValue.username;

        console.log(`Triggered for order: ${orderId}`);

        // 1. Fetch Admin users with strict validation
        const tokensSnapshot = await admin.firestore()
            .collection("registeredUsers")
            .where("role", "==", "Admin")
            .get();

        // 2. Validate both role and token field
        const validAdminTokens = tokensSnapshot.docs
            .filter((doc) => {
              const data = doc.data();
              return data.role === "Admin" &&
               data.fcmToken;
            })
            .map((doc) => doc.data().fcmToken); // Basic FCM format check

        console.log(`Found ${validAdminTokens.length} valid admin tokens`);

        if (validAdminTokens.length === 0) {
          console.log("No valid admin tokens available");
          return;
        }

        // 3. Prepare and send notification
        const payload = {
          notification: {
            title: "New Order Received!",
            body: `Order ID: ${orderId} from ${customerName}`,
            // click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          data: {
            orderId: orderId,
            customerName: customerName,
            notificationType: "adminOrderAlert", // Add type for client handling
          },
          tokens: validAdminTokens,
        };

        const response = await admin.messaging().sendEachForMulticast(payload);

        console.log(`Successfully sent to ${response.successCount} admins`);
        console.log(`Failed attempts: ${response.failureCount}`);
      } catch (error) {
        console.error("Notification error:", error);
        if (error.errorInfo) {
          console.error("Firebase error details:", error.errorInfo);
        }
      }
    });

exports.sendOrderStatusUpdate = onDocumentUpdated(
    "Orders/{orderId}",
    async (event) => {
      try {
        const afterData = event.data.after.data();

        const newStatus = afterData.Status;
        const patientId = afterData.user_id;
        const orderId = event.params.orderId;

        // Get patient's FCM token
        const patientDoc = await admin.firestore()
            .collection("registeredUsers") // Your patient collection name
            .doc(patientId)
            .get();

        if (!patientDoc.exists) {
          console.error("Patient document not found:", patientId);
          return;
        }

        const patientData = patientDoc.data();
        const patientTokenValue = patientData.patientToken;

        if (patientData.role !== "Patient") {
          console.error("Notification rejected - User role:", patientData.role);
          return;
        }

        if (!patientTokenValue) {
          console.error("No patientToken found for patient:", patientId);
          return;
        }

        // Prepare notification payload
        const payload = {
          notification: {
            title: "Order Status Updated",
            body: `Your order ${orderId} is now ${newStatus}`,
            // click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          data: {
            orderId: orderId,
            newStatus: newStatus,
            type: "statusUpdate", // For handling in Flutter
            android_channel_id: "orders_channel",
          },
          token: patientTokenValue,
        };

        // Send notification
        const response = await admin.messaging().send(payload);
        console.log("Successfully sent notification:", response);
      } catch (error) {
        console.error("Error sending status update:", error);
        if (error.errorInfo) {
          console.error("Firebase error details:", error.errorInfo);

          // Auto-clean invalid tokens
          //   console.log("Attempting to remove invalid token...");
          //   await admin.firestore()
          //       .collection("registeredUsers")
          //       .doc(patientId)
          //       .update({
          //         patientToken: admin.firestore.FieldValue.delete(),
          //       });
          // }
        }
      }
    });
