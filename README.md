# PruebaLaboral

¡Buenos días! Espero esté bien.

Para el uso apropiado de la base de datos y sus objetos, puede utilizar el archivo Mardom_DEV_y_registros.sql o 
el Mardom_PRO_y_registros.sql ya que son identicos.

Antes de seguir por acá, es bueno mencionar que en el archivo llamado "Documentación Resultados de prueba Analista Desarrollador de Base de Datos.docx"
(un poco largo el nombre, ¿no?) el cual está en este repositorio, está también explicado la realización de las 4 partes de la prueba y con imágenes explicativas
lo cual considero es más apropiado.

En la primera parte de la prueba se requiere que se puede generar un código que sea único e irrepetible, para eso
se debe usar antes que cualquier otra cosa la siguiente sentencia SQL para se genere e inicie un contador como objeto de la base de datos.

  CREATE SEQUENCE dbo.contador1  
    START WITH 1  
    INCREMENT BY 1;

Para poder generar la secuencia se debe utilizar un procedimiento almacenado llamado sp_SecuencialProducto al que 
se le debe pasar dos argumentos, estos deben tomarse de los valores de las tablas pruebaSec y tipoPruebaSec. Por ejemplo: 'Seco', 'Ropa'.

Las próximas tres situaciones a tratar considero se explican mejor por sus imágenes desde 
el archivo "Documentación Resultados de prueba Analista Desarrollador de Base de Datos.docx".
