import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void enviarEmail(Map<String, dynamic> datos) async {
  String username = 'pro.univalle2022@gmail.com';
  String password = 'dyjmdcjukkckzutn';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'AdopCats')
    ..recipients.add(datos['Dueño_Email'])
    ..subject = 'AdopCats - Nueva Solicitud de adopción'
    ..html = '<h1><img src="paw_color.png" width="50px" height="50px" style="margin-right: 15px;">AdopCats</h1>'
        "<p>Hola, has recibido una nueva solicitud de adopción: </p>"
        "<h3>Datos del Solicitante</h3>"
        "<p><strong>Nombre: </strong>${datos['datos_personales']['nombre']}</p>"
        "<p><strong>Apellido: </strong>${datos['datos_personales']['apellido']}</p>"
        "<p><strong>DNI: </strong>${datos['datos_personales']['dni'] + " " + datos['datos_personales']['extencion']}</p>"
        "<p><strong>Edad: </strong>${datos['datos_personales']['edad']}</p>"
        "<p><strong>Direccion: </strong>${datos['datos_personales']['direccion']}</p>"
        "<p><strong>Telefono: </strong>${datos['datos_personales']['telefono']}</p>"
        "<p><strong>Correo: </strong>${datos['datos_personales']['email']}</p>"
        "<h3>Datos Familiares</h3>"
        "<p><strong>¿Vive con su familia?: </strong>${datos['datos_familiares']['familia']}</p>"
        "<p><strong>¿Tiene hijos?: </strong>${datos['datos_familiares']['hijos']}</p>"
        "<p><strong>¿Qué edad tienen?: </strong>${datos['datos_familiares']['edad_hijos']}</p>"
        "<p><strong>¿Tiene mascotas?: </strong>${datos['datos_familiares']['otras_mascotas']}</p>"
        "<p><h3>Datos laborales</h3>"
        "<p><strong>¿Tiene trabajo?: </strong>${datos['datos_laborales']['trabajo']}</p>"
        "<p><strong>¿Viaja mucho?: </strong>${datos['datos_laborales']['viajes']}</p>"
        "<h3>Datos de la vivienda</h3>"
        "<p><strong>¿Vive en casa o departamento?: </strong>${datos['datos_vivienda']['tipo']}</p>"
        "<p><strong>¿Tiene patio?: </strong>${datos['datos_vivienda']['jardin']}</p>"
        "<p><strong>¿Tiene Experiencia con Mascotas?: </strong>${datos['experiencia']}</p>"
        "<p><strong>Motivo de adopción: </strong>${datos['mensaje']}</p>";
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n' + e.toString());
  }

  var connection = PersistentConnection(smtpServer);
  await connection.send(message);
  await connection.close();
}
