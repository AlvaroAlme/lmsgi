apuntes XQUERY
---------------
sintaxis FLWOR
FOR - crea una variable (precedido por $) creando un conjunto de elementos que asocia a esa variable IN DOC()
LET - nos permite almacenar en variables el resultado de evaluar expresiones, puedes usar varios let o un solo let y separas por comas
WHERE
ORDER BY
RETURN



----
usar bookstore.xml
E.1:
Mostrar los titulos de los libros con la etiqueta <titulo>

for $titulo in doc("bookstore")//bookstore//book/title/text()
return $titulo


E.11:
Mostrar el titulo del libro, su precio, su precion con IVA, cada uno con su propia etiqueta. Ordenalos por precio con IVA

for $libro in doc("bookstore")//bookstore/book
let $precio_iva := ($libro/price *1.21)
order by $precio_iva
return
<libro>
	<titulo>{$libro/title/text()}</titulo>
	<precio>{$libro/price/text()}</precio>
	<precio_iva>{$precio_iva}€</precio_iva>
</libro>

E.5:
Mostrar el título y el autor de los libros del año 2005, y etiquetar cada uno de ellos
con «lib2005».

for $libro in doc("bookstore")//bookstore/book
where $libro/year = 2005
return
<lib2005>{$libro/title,$libro/author}</lib2005>

E.9:
Mostrar los títulos de los libros y al final una etiqueta con el número total de libros.

<resultado>
	{
		for $libro in doc("bookstore")/bookstore/book
		return <titulo>{$libro/title/text()}</titulo>
	}
	{
		let $total_libros := count($libros)
		return <total_libros>{$total_libros}</total_libros>
</resultado>

E.10:
Mostrar el precio minimo y maximno de los libros


let $max := max(/bookstore/book/price)
let $min := min(/bookstore/book/price)
return
<resultado> 
	<max>{$max}</max>
	<min>{$min}</min>
</resultado>

E.2
Muestra los libros cuyo precio sea menor o igual a 30. Primero incluyendo la condicion en la clausula where y luego en la ruta xPATH

for $libro in doc("bookstore")/bookstore/book
where $libro/price <= 30
return $libro

for $libro in doc("bookstore")/bookstore/book[price <= 30]
return $libro

E. 18
Mostrar los libros que tengan una "X" mayuscula o minuscula en el titulo.

for $libro in doc("bookstore")/bookstore/book
where contains(upper-case($libros/title), "X")//cambia todo a mayuscula para poder comparar con mayuscula.
return $libro
------
for $libro in doc("bookstore")/bookstore/book[contains(lower-case(title), "x")]
return $libro

------------------------
contains() => "contiene", primero la funcion > entre parentesis los "parametros", (DONDE tiene que buscar, QUE tiene que buscar)
count() => "cuenta"
avg() => calcula la media

 "¿Qué bailes tienen más plazas que la media de
plazas de todos los bailes?"

for $baile in doc("BD_Bailes")//baile
let $media := avg(doc("BD_Bailes")//baile/plazas)
where $baile/plazas > $media
return ($baile/nombre,$baile/plazas)

"Este ejemplo, saca la media del numero de miembros que tiene la organizacion. Puedes añadir la funcion ANTES de empear con el for"

avg (
for $organizaciones in doc(‘factbook’) /mondial/organization
return count ($organizaciones/members)
)

"ahora la media redondeada a 2 decimales, como siempre 1º la funcion, despues los parametros, en este caso el primer parametro es el QUE tiene que redondear, el segundo, el numero de decimales que quiero"
round-half-to-even (
    avg (
        for $organizaciones in
        doc('factbook')/mondial/organization
        return count ($organizaciones/members)
    ),2
)


TAREA 06:
Se pide al alumno que confeccione, mediante XQuery sobre BaseX, una página
completa HTML en la que se pueda ver una tabla con este aspecto y contenido:

<html>
  <table border='1'>
    <tr>
    <th>Alumno</th>
    <th>Tema</th>
    <th>Título</th>
    <th>Pregunta</th>
    <th>Enunciado</th>
    <th>Resp. alu.</th>
    <th>Resp. ok</th>
    <th>Puntos</th> 
    </tr>    
    {
      for $alumno in /modulo/resultados/alumno
      let $nombre := $alumno/@nombre/data()
      
      for $respuesta in $alumno/respuesta      
      let $unidad_id := $respuesta/@unidad/data()
      let $unidad := /modulo/unidades/unidad[@id = $unidad_id]
      let $unidad_nombre := $unidad/@nombre/data()
      let $test_id := $respuesta/@test/data()
      let $test := /modulo/unidades/unidad/test[@id = $test_id]
      let $test_enunciado := $test/enunciado/data()
      let $test_orden := $test/@orden/data()
      let $respuesta_alumno := $respuesta/@marca/data()
      let $respuesta_ok := $test/opciones/opcion[@correcta = "true"]/@rotulo/data()
      let $puntos := if ($respuesta_alumno = $respuesta_ok) then 1 else -0.25
      order by $nombre, $unidad_id, $test_orden
      return
        <tr>
          <td>{$nombre}</td>
          <td>{$unidad_id}</td>
          <td>{$unidad_nombre}</td>
          <td>{$test_id}</td>
          <td>{$test_enunciado}</td>
          <td>{$respuesta_alumno}</td>
          <td>{$respuesta_ok}</td>
          <td>{$puntos}</td>
    </tr> 
      
    }
  </table>
</html>

APUNTES xPATH
------------------
1.- Seleccionar todos los libros de la biblioteca.
/bookstore/book

2.- Seleccionar el primer libro de la biblioteca.
1/bookstore/book[1]

3.- Seleccionar el último libro de la biblioteca.
/bookstore/book[last()]

4.- Seleccionar el libro que ocupa la segunda posición de la biblioteca.
/bookstore/book[2]

5.- Seleccionar todos los títulos de la biblioteca.
/bookstore/book/title

6.- Seleccionar todos los títulos en general.
//title

7.- Seleccionar los nombres de los títulos de la biblioteca.
/bookstore/book/title/string()

8.- Seleccionar todos los libros cuyo título sea “Harry Potter” de la biblioteca.
/bookstore/book[title="Harry Potter"]

9.- Seleccionar el nombre del autor de todos los libros cuyo título sea “Harry Potter” de la
biblioteca.
/bookstore/book[title="Harry Potter"]/author/string()

10.- Seleccionar todos los libros cuyo precio sea mayor a 30 de la biblioteca.
/bookstore/book[price > 30]

11.- Seleccionar todos los nombres de títulos de libros cuyo precio sea mayor a 30 y el año de
publicación sea 2003 de la biblioteca.
/bookstore/book[price > 30 and year=2003]/title/string()

12.- Seleccionar todas las categorías de libros existentes en la biblioteca.
/bookstore/book/@category/string()

13.- Seleccionar todos los precios de libros cuya categoría sea “WEB” de la biblioteca.
/bookstore/book[@category="WEB"]/price

14.- Seleccionar todos los precios de libros cuya categoría sea “WEB” y precio sea menor que 40
de la biblioteca.
/bookstore/book[@category="WEB" and price < 40]/price

15.- Seleccionar el título y el precio de todos los libros de la biblioteca.
Formas:
1. /bookstore/book/title|/bookstore/book/price
2. /bookstore/book/(title|price)

16.- Seleccionar el autor y el año de publicación de los libros de cualquier categoría distinta de
“WEB” y título en inglés de la biblioteca.
/bookstore/book[@category!="WEB"]/title[@lang="en"]/../(author|year)

17.- Seleccionar todos los nombres de títulos de libros cuyos precios redondeados sean 30 de la
biblioteca.
/bookstore/book[round(price)=30]/title/string()

18.- Seleccionar todos los títulos de libros cuyo nombre empiece por “Ha” de la biblioteca.
/bookstore/book[starts-with(title,"Ha")]/title/string()

19.- Seleccionar los títulos de libros que tengan más de un autor de la biblioteca.
/bookstore/book[count(author)>1]/title

20.- Seleccionar el nombre del título del libro más caro de la biblioteca.
/bookstore/book[price = max(/bookstore/book/price)]/title/string()



--------------------
APUNTES XSLT

//Para asociar una hoja de estilos xslt a un archivo xml es:
<?xml-stylesheet type="text/xsl" href="ruta-al-archivo-xsl"?>
//La manera de empezar una hoja de estilos xslt es asi
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

//Para hacer un salto de linea <xsl:text>&#10</xsl:text>

1.- Obtener el siguiente fichero HTML sin etiquetas:
<?xml version="1.0" encoding="UTF-8"?>
 Administración de Sistemas Informáticos en Red
 Desarrollo de Aplicaciones Web
 Sistemas Microinformáticos y Redes

=>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    <xsl:for-each select="ies/ciclos/ciclo">
        <xsl:value-of select="nombre"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
-------------------------------------------------------------------------------------------

2.- Obtener el siguiente fichero HTML con párrafos:
<?xml version="1.0" encoding="UTF-8"?>
<html>
<p>Administración de Sistemas Informáticos en Red</p>
<p>Desarrollo de Aplicaciones Web</p>
<p>Sistemas Microinformáticos y Redes</p>
</html>

=>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
   <hml>
     <xsl:for-each select="/ies/ciclos/ciclo">
      <p><xsl:value-of select="nombre"/></p>
     </xsl:for-each>
   </hml>
  </xsl:template>
</xsl:stylesheet>
-------------------------------------------------------------------------------------------
3.- Obtener el siguiente fichero HTML con listas:
<?xml version="1.0" encoding="UTF-8"?>
<html>
 <ul>
<li>Administración de Sistemas Informáticos en Red</li>
<li>Desarrollo de Aplicaciones Web</li>
<li>Sistemas Microinformáticos y Redes</li>
 </ul>
</html>

=>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
  <html>
   <ul>
     <xsl:for-each select="ies/ciclos/ciclo">
        <li><xsl:value-of select="nombre"/></li>
     </xsl:for-each>
   </ul>  
  </html>
  </xsl:template>
</xsl:stylesheet>

-------------------------------------------------------------------------------------------
4.- Obtener el siguiente fichero HTML con tablas:
<?xml version="1.0" encoding="UTF-8"?>
<html>
 <table border="1">
 <tr>
 <td>Administración de Sistemas Informáticos en Red</td>
 </tr>
 <tr>
 <td>Desarrollo de Aplicaciones Web</td>
 </tr>
 <tr>
 <td>Sistemas Microinformáticos y Redes</td>
 </tr>
 </table>
</html>

=>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
   <hml>
    <table border="1">   
    <xsl:for-each select="ies/ciclos/ciclo">
      <tr><xsl:text>&#10;</xsl:text>
         <td><xsl:value-of select="nombre"/></td><xsl:text>&#10; </xsl:text>
      </tr>
    </xsl:for-each>
  </table>
  </hml>  
  </xsl:template>
</xsl:stylesheet>

-------------------------------------------------------------------------------------------
5.- Obtener el siguiente fichero HTML con párrafos:
<?xml version="1.0" encoding="UTF-8"?>
<html>
<h1>CIFP La conservera</h1>
<p>Administración de Sistemas Informáticos en Red</p>
<p>Desarrollo de Aplicaciones Web</p>
<p>Sistemas Microinformáticos y Redes</p>
</html>

=>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    <html>
      <xsl:for-each select="ies">
          <h1><xsl:value-of select="@nombre"/></h1>
          <xsl:for-each select="ciclos/ciclo">
            <p><xsl:value-of select="nombre"/></p>
          </xsl:for-each>
      </xsl:for-each>
    </html>
  </xsl:template>
</xsl:stylesheet>

-------------------------------------------------------------------------------------------
6.- Obtener el siguiente fichero HTML con listas:
<?xml version="1.0" encoding="UTF-8"?>
<html>
<h1>CIFP La conservera</h1>
<p>Página web: <a href="http://www.fplaconservera.es/">http://www.fplaconservera.es/</a></p>
<ul>
<li>Administración de Sistemas Informáticos en Red</li>
<li>Desarrollo de Aplicaciones Web</li>
<li>Sistemas Microinformáticos y Redes</li>
 </ul>
</html>

=>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    <html>
      <xsl:for-each select="ies">
        <h1><xsl:value-of select="@nombre" /></h1>
        <p>Página web: <a >
        <xsl:attribute name="href">
          <xsl:value-of select="@web" />
        </xsl:attribute>
      <xsl:value-of select="@web" /></a></p>
      <ul>
       <xsl:for-each select="ciclos/ciclo">
         <li><xsl:value-of select="nombre"/></li>
       </xsl:for-each>
      </ul>
      </xsl:for-each>
    </html>
   </xsl:template>
</xsl:stylesheet>
-------------------------------------------------------------------------------------------
7.- Obtener el siguiente fichero HTML con tablas:
<?xml version="1.0" encoding="UTF-8"?>
<html>
<h1>CIFP La conservera</h1>
<p>Página web: <a href="http://www.fplaconservera.es/">http://www.fplaconservera.es/</a></p>
<table border="1">
<tr>
 <th>Nombre del ciclo</th>
 <th>Grado</th>
 <th>Año del título</th>
 </tr>
 <tr>
 <td>Administración de Sistemas Informáticos en Red</td>
 <td>Superior</td>
 <td>2009</td>
 </tr>
 <tr>
 <td>Desarrollo de Aplicaciones Web</td>
 <td>Superior</td>
 <td>2010</td>
 </tr>
 <tr>
 <td>Sistemas Microinformáticos y Redes</td>
 <td>Medio</td>
 <td>2008</td>
 </tr>
</table>
</html>

=>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
  <html>
     <xsl:for-each select="ies">
      <h1><xsl:value-of select="@nombre" /></h1>
      <p>Página web: <a><xsl:attribute name="href"><xsl:value-of select="@web"/></xsl:attribute><xsl:value-of select="@web"/></a></p>
      <table border="1"><xsl:text>&#10;</xsl:text>
      <tr><xsl:text>&#10; </xsl:text>
        <th>Nombre del ciclo</th><xsl:text>&#10; </xsl:text>
        <th>Grado</th><xsl:text>&#10; </xsl:text>
        <th>Año del título</th><xsl:text>&#10; </xsl:text>
      </tr><xsl:text>&#10; </xsl:text>
      <xsl:for-each select="ciclos/ciclo">
      <tr><xsl:text>&#10;</xsl:text>
        <td><xsl:value-of select="nombre"/></td><xsl:text>&#10;</xsl:text>
        <td><xsl:value-of select="grado"/></td><xsl:text>&#10;</xsl:text>
        <td><xsl:value-of select="decretoTitulo/@año"/></td><xsl:text>&#10;</xsl:text>
      </tr><xsl:text>&#10;</xsl:text>
      </xsl:for-each>
      </table>
     </xsl:for-each>
     </html>
  </xsl:template>
</xsl:stylesheet>





