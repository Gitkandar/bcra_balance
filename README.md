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

Las variables que se seleccionan mediante el código son las siguientes:

-   **fecha**: la variable fecha se utiliza como id en el *dataframe*. Generalmente corresponde al día viernes de cada semana
-   **dia**: el número del día correspondiente a fecha.
-   **mes**: el número de mes correspondiente a fecha.
-   **anio**: el número de año correspondiente a fecha.
-   **tipo_cambio**: el tipo de cambio oficial que utiliza el BCRA para hacer las conversiones de sus activos y pasivos.
-   **base_monetaria**: la base monetaria del BCRA.
-   **adelantos_transitorios**: son los adelantos transitorios del BCRA al gobierno nacional.
-   **letras_intrasferibles**: monto total de letras instransferibles en manos del central por el origen que sea (decreto, ley, etc).
-   **reservas_pesos**: agregado monetario de las reservas del BCRA denominadas en pesos.
-   **titulos_bcra**: títulos emitidos por el BCRA
-   **credito_sist_financiero**: créditos al sistema financiero del país.
-   **activo_bcra**: activo del balance del BCRA.
-   **pasivo_bcra**: pasivo del balance del BCRA.
-   **reservas_dolares**: reservas del BCRA denominadas en dólares. NOTA: Se utiliza el tipo de cambio que provee el BCRA para realizar la conversión.
-   **ratio_reservas_base**: el ratio de las reservas contra la base monetaria del BCRA.

## Estado del Proyecto

A septiembre de 2023, el proyecto se encuentra activo. Eso significa que:

-   Se provee mantenimiento, sobre todo en lo que refiere a los cambios de año, que generalmente incluyen alguna modificación en el formato o tabulado de los datos de origen.
-   Se busca ampliar la base de variables a filtrar.

## Créditos

**Elaboración final y mantenimiento**:

-   Germán Adolfo Tessmer. [LinkedIn](https://www.linkedin.com/in/gtessmer/). [ORCID](https://orcid.org/0000-0002-3827-7027)

**Elaboración original**:

-   Lucia Papa. [LinkedIn](https://www.linkedin.com/in/lic-lucia-papa/). [ORCID](https://orcid.org/0000-0002-3827-7027)
-   Diego Marfetán Molina. [LinkedIn](https://www.linkedin.com/in/diegomarfetan/). [ORCID](https://orcid.org/0000-0003-4638-0902)

**Han colaborado en la elaboración de éste código o en los fundamentos conceptuales del mismo**:

-   Luciano Jara Musuruana. [LinkedIn](https://www.linkedin.com/in/luciano-jara-musuruana/). [ORCID](https://orcid.org/0000-0002-0203-180X)
-   Gastón Navarro. [LinkedIn](https://www.linkedin.com/in/gast%C3%B3n-navarro-aa58661b3/).

## Contacto

Germán Tessmer: [ger.tessmer\@gmail.com](ger.tessmer@gmail.com). [LinkedIn](https://www.linkedin.com/in/gtessmer/).
