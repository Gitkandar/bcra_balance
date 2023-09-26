# Balance semanal del BCRA

Proceso de extracción y tratamiento de datos de la hoja semanal del balance del Banco Central de la República Argentina (BCRA).

## Uso

Este código permite la extracción de las series de tiempo de las variables o cuentas del balance semanal del BCRA desde el 07 de enero de 1998 a la fecha bajo el programa [R](https://www.r-project.org/).

En su interior, hay un encabezado titulado "Datos a modificar". El valor de la variable `ult` debe modificarse a los fines de incluir o excluir el último año que se desea descargar. Por ejemplo, `ult <- 23` va a descargar y ordenar la base desde el 07 de enero de 1998 a el último dato disponible del año 2023.

El resultado es el de un *dataframe* ordenado (*tidy*) con variables seleccionadas sobre las cuales operar. Dado que el énfasis está puesto en el diseño del código de extracción y tratamiento, debe esperarse que el *output* del mismo, que se guarda en el archivo `balance_bcra.csv` no se encuentre necesariamente actualizado.

## Archivos

-   **bcra_balance.R**: Código de extracción de las hojas de balance del BCRA. Recorre todos los años que se presentan.
-   **SerieBCRA.xls**: Archivo excel directamente descargado del portal del BCRA. Esta acción se ejecuta desde el código R aquí presentado.
-   **balance_bcra.csv**: Output del código R.

## Variables seleccionadas

Se ha seleccionado un conjunto de variables de la hoja de balance del BCRA. No todas presentan el mismo nivel de agregación. Es por ello que el nombre de cada variable es seguido por un clasificador entre corchetes, según el nivel de desagregación:

-   **N0**: máximo nivel de agregación
-   **N1 nombre_variable**: segundo nivel de agregación. El parámetro *nombre_variable* remite a la variable inmediatamente más agregada a la que esta pertenece. En este caso, del nivel 0.
-   **N2 nombre_variable**: tercer nivel de agregación. El parámetro *nombre_variable* remite a la variable inmediatamente más agregada a la que esta pertenece. En este caso, del nivel 1.
-   **CALC**: variable calculada. Es decir, no pre-existente en la base de datos de origen.

Las variables que se seleccionan mediante el código son las siguientes. Todas se encuentran expresadas en millones de pesos ($ millones):

-   **fecha** [*N0*]: la variable fecha se utiliza como id en el *dataframe*. Generalmente corresponde al día viernes de cada semana.
-   **dia** [*N0*]: el número del día correspondiente a fecha.
-   **mes** [*N0*]: el número de mes correspondiente a fecha.
-   **anio** [*N0*]: el número de año correspondiente a fecha.
-   **tipo_cambio** [*N0*]: el tipo de cambio oficial que utiliza el BCRA para hacer las conversiones de sus activos y pasivos.
-   **activo_bcra** [*N0*]: activo del balance del BCRA.
-   **reservas_pesos** [*N1 activo_bcra*]: agregado monetario de las reservas del BCRA denominadas en pesos.
-   **divisas_pesos** [*N2 reservas_pesos*]: divisas disponibles en las reservas del BCRA denominadas en pesos.
-   **convenio_multilateral** [*N2 reservas_pesos*]: convenios multilaterales de crédito por parte del BCRA, denominado en pesos.
-   **titulos_publicos** [*N1 activo_bcra*]: títulos públicos bajo ley nacional y extranjera a favor del BCRA.
-   **adelantos_transitorios** [*N1 activo_bcra*]: son los adelantos transitorios del BCRA al gobierno nacional.
-   **credito_sist_financiero** [*N1 activo_bcra*]: créditos al sistema financiero del país.
-   **pasivo_bcra** [*N0*]: pasivo del balance del BCRA.
-   **base_monetaria** [*N1 pasivo_bcra*]: la base monetaria del BCRA.
-   **circulacion_monetaria** [*N2 base_monetaria*]: billetes, monedas y cheques cancelatorios en circulación.
-   **oblig_organismos_internales** [*N1 pasivo_bcra*]: obligaciones del BCRA establecidas con organismos internacionales.
-   **titulos_emitidos_bcra** [*N1 pasivo_bcra*]: títulos emitidos por el BCRA.
-   **letras_intrasferibles** [*N2 titulos_emitidos_bcra*]: monto total de letras instransferibles en manos del central por el origen que sea (decreto, ley, etc).
-   **reservas_dolares** [*CALC*]: reservas del BCRA denominadas en dólares. NOTA: Se utiliza el tipo de cambio que provee el BCRA para realizar la conversión.
-   **ratio_reservas_base** [*CALC*]: el ratio de las reservas contra la base monetaria del BCRA.

## Estado del Proyecto

A septiembre de 2023, el proyecto se encuentra activo. Eso significa que se provee mantenimiento, sobre todo en lo que refiere a los cambios de año, que generalmente incluyen alguna modificación en el formato o tabulado de los datos de origen.

## Créditos

**Elaboración final y mantenimiento**:

-   Germán Adolfo Tessmer. [LinkedIn](https://www.linkedin.com/in/gtessmer/). [ORCID](https://orcid.org/0000-0002-3827-7027)

**Elaboración original**:

-   Lucia Papa. [LinkedIn](https://www.linkedin.com/in/lic-lucia-papa/). [ORCID](https://orcid.org/0000-0002-3827-7027)
-   Diego Marfetán Molina. [LinkedIn](https://www.linkedin.com/in/diegomarfetan/). [ORCID](https://orcid.org/0000-0003-4638-0902)

**Han colaborado en la elaboración de éste código o en los fundamentos conceptuales del mismo**:

-   Luciano Jara Musuruana. [LinkedIn](https://www.linkedin.com/in/luciano-jara-musuruana/). [ORCID](https://orcid.org/0000-0002-0203-180X)
-   Patricio Almeida Gentille. [LinkedIn](https://www.linkedin.com/in/patricio-almeida-gentile-5bbb7414a/). [ORCID](https://orcid.org/0000-0002-0308-9165)

## Contacto

Germán Tessmer\
email: [ger.tessmer\@gmail.com](ger.tessmer@gmail.com)\
[LinkedIn](https://www.linkedin.com/in/gtessmer/)
