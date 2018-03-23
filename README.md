# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo;
2. Implementar un algoritmo de anti-aliasing para sus aristas; y,
3. Hacer shading sobre su superficie.

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases).

## Integrantes

Máximo 3.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|       Gil Castellanos Luis Ernesto     |    juasmartinezbel         |
|       Martínez Beltrán Juan Sebastián     |  luegilca          |

## Discusión

Describa los resultados obtenidos. ¿Qué técnicas de anti-aliasing y shading se exploraron? Adjunte las referencias. Discuta las dificultades encontradas:

Quizás lo que más nos tomó tiempo fue lograr entender la librería y la forma en que trataba la matríz en buena parte para poder comprender dónde empezar.
En un inicio hacer el rastering nos pareció intimidante por esto mismo, pero una vez tuvimos el tiro, logramos sacarlo con bastante facilidad.
Las dudas comenzaron ya con el tema de shading y antialiasing, ya que al aplicar los métodos referenciados hubieron problemas, pero fue más que nada por el entendimiento y funcionamiento de la librería, una vez los conceptos claros y una división más precisa del entorno para realizar la tarea, los resultados salieron bastante satisfactorios y aplicables.
En cuanto a los resultados sí es algo frustrante ver como el programa se realentiza por las limitaciones, pero sabemos el porque suceden.
##### Referencias Utilizadas:
* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization Stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)
* [Anti-alising](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation)

## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes (de las que se tomará una al azar).
* Plazo: 1/4/18 a las 24h.
