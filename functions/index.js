const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");

initializeApp();

exports.onItemCreation = onDocumentCreated("solicitudes/{solicitudesId}",
    async (snapshot) => {
      const itemDataSnap = await snapshot.ref.get();
      const $ownerEmail = itemDataSnap.data().Dueño_Email;
      const applicantEmail = itemDataSnap.data().email;
      const Email = await new Email(applicantEmail)
          .setSubject("Nueva solicitud de Adopcion")
          .setBody("Nueva solicitud de adopcion para tu gato"+snapshot.id)
          .sendTo($ownerEmail);
      console.log("Email sent successfully");
    },
);


