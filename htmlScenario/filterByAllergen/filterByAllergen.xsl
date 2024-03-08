<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Define the excluded allergenId for gluten using XPath -->
    <xsl:variable name="excludedAllergenId" select="//allergen[text()='gluten']/@allergenId"/>

    <!-- Define a variable for ingredient names -->
    <xsl:variable name="ingredientNames" select="/recipeBook/ingredients/ingredient"/>

    <!-- Root template -->
    <xsl:template match="/">
        <!-- Start HTML document -->
        <html>
            <head>
                <title>Recipes Without Gluten</title>
                <!-- Include the generated CSS file -->
                <link rel="stylesheet" type="text/css" href="styles.css"/>
            </head>
            <body>
                <div class="recipeBook-container">
                    <!-- Apply the template to select recipes without the excluded allergenId -->
                    <xsl:apply-templates select="//recipe[not(allergens/allergen/@allergenId = $excludedAllergenId)]"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Template to match recipes without the excluded allergenId -->
    <xsl:template match="recipe">
        <!-- Display recipe information -->
        <div class="recipe-container">
            <h2><xsl:value-of select="name"/></h2>
            <!-- Display recipe image -->
            <img class="recipe-image" src="{image}" alt="Recipe Image"/>
            <p class="ingredients-title"><strong>Ingredients:</strong></p>
            <ul class="ingredients-list">
                <!-- Apply the template to select ingredients -->
                <xsl:apply-templates select="ingredients/ingredient"/>
            </ul>
            <p class="steps-title"><strong>Steps:</strong></p>
            <ol class="steps-list">
                <!-- Apply the template to select steps -->
                <xsl:apply-templates select="steps/step"/>
            </ol>
        </div>
    </xsl:template>

    <!-- Template to match ingredients -->
    <xsl:template match="ingredient">
        <li>
            <!-- Display ingredient name based on the ingredientId -->
            <xsl:value-of select="$ingredientNames[@ingredientId = current()/@ingredientId]"/>
            <!-- Display quantity -->
            - <xsl:value-of select="quantity"/>
        </li>
    </xsl:template>

    <!-- Template to match steps -->
    <xsl:template match="step">
        <li>
            <!-- Display step image -->
            <img class="step-image" src="{photo}" alt="Step Image"/>
            <!-- Display step description -->
            <p><xsl:value-of select="description"/></p>
        </li>
    </xsl:template>

</xsl:stylesheet>
