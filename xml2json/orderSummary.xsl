<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>

    <!-- Define the wanted order using XPath variable -->
    <xsl:variable name="order" select="//order[@orderId='b934abac0d4c44e7afaafd4035fdccd0']" />

    <xsl:template match="/">

        <xsl:text>{&#10;</xsl:text>
        <xsl:text>&#9;"$schema" : "./outputSchema.json",&#10;</xsl:text>
        <xsl:text>&#9;"orderId": "</xsl:text>
        <xsl:value-of select="$order/@orderId"/>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>&#9;"customer": {&#10;</xsl:text>
        <xsl:text>&#9;&#9;"name": "</xsl:text>
        <xsl:value-of select="//users/user[@userId=$order/@userId]/text()"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>&#9;&#9;"address": "</xsl:text>
        <xsl:value-of select="$order/address"/>
        <xsl:text>"&#10;</xsl:text>
        <xsl:text>&#9;},&#10;</xsl:text>

        <xsl:text>&#9;"content": [&#10;</xsl:text>

        <xsl:apply-templates select="$order/recipes/recipe"/>
        <xsl:text>&#9;],&#10;</xsl:text>

        <xsl:text>&#9;"totalPrice": </xsl:text>

        <xsl:call-template name="totalPrice">
            <xsl:with-param name="recipes" select="$order/recipes/recipe"/>
            <xsl:with-param name="totalPrice" select="0"/>
        </xsl:call-template>

        <xsl:text>&#10;</xsl:text>

        <xsl:text>}</xsl:text>

    </xsl:template>

    <xsl:template match="recipe">
        <xsl:text>&#9;&#9;{&#10;</xsl:text>
        <xsl:text>&#9;&#9;&#9;"recipeId": "</xsl:text>
        <xsl:value-of select="@recipeId"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>&#9;&#9;&#9;"pricePerUnity": </xsl:text>
        <xsl:value-of select="//recipeBook/recipes/recipe[@recipeId=current()/@recipeId]/@price"/>
        <xsl:text>,&#10;</xsl:text>
        <xsl:text>&#9;&#9;&#9;"quantity": </xsl:text>
        <xsl:value-of select="current()/@quantity"/>
        <xsl:text>&#10;&#9;&#9;}</xsl:text>
        <xsl:if test="position() != last()">,</xsl:if>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

    <!-- Template to compute the total price recursively -->
    <xsl:template name="totalPrice">
        <!-- Parameters: $recipes - the list of recipe elements, $totalPrice - the current total price -->
        <xsl:param name="recipes"/>
        <xsl:param name="totalPrice"/>

        <!-- Base case: if there are no more recipes, output the total price -->
        <xsl:if test="count($recipes) = 0">
            <xsl:value-of select="$totalPrice"/>
        </xsl:if>

        <!-- Recursive case: if there are recipes remaining, process the first recipe -->
        <xsl:if test="count($recipes) &gt; 0">
            <!-- Retrieve the first recipe in the list -->
            <xsl:variable name="recipe" select="$recipes[1]"/>

            <!-- Retrieve the quantity and recipe ID -->
            <xsl:variable name="quantity" select="$recipe/@quantity"/>
            <xsl:variable name="recipeId" select="$recipe/@recipeId"/>

            <!-- Retrieve the price of the recipe from the recipeBook -->
            <xsl:variable name="price" select="//recipeBook/recipes/recipe[@recipeId = $recipeId]/@price"/>

            <!-- Calculate the subtotal for this recipe -->
            <xsl:variable name="subtotal" select="$quantity * $price"/>

            <!-- Recursive call to totalPrice with the remaining recipes and updated total price -->
            <xsl:call-template name="totalPrice">
                <xsl:with-param name="recipes" select="$recipes[position() &gt; 1]"/>
                <xsl:with-param name="totalPrice" select="$totalPrice + $subtotal"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>