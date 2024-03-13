<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <adminBoard>
            <recipes count="{count(//recipe)}">
                <xsl:apply-templates select="recipeBook/recipes/recipe"/>
            </recipes>
            <ingredients count="{count(//ingredient)}">
                <xsl:apply-templates select="recipeBook/ingredients/ingredient"/>
            </ingredients>
            <tools count="{count(//tool)}">
                <xsl:apply-templates select="recipeBook/tools/tool"/>
            </tools>
            <users count="{count(//user)}">
                <xsl:apply-templates select="recipeBook/users/user"/>
            </users>
        </adminBoard>
    </xsl:template>

    <xsl:template match="recipe">
        <recipe>
            <name><xsl:value-of select="name"/></name>
            <averageGrade><xsl:value-of select="sum(userRatings/userRate/@grade) div count(userRatings/userRate)"/></averageGrade>
            <numberOfIngredients><xsl:value-of select="count(ingredients/ingredient)"/></numberOfIngredients>
            <numberOfTools><xsl:value-of select="count(tools/tool)"/></numberOfTools>
        </recipe>
    </xsl:template>

    <xsl:template match="ingredient">
        <ingredient>
            <name><xsl:value-of select="."/></name>
            <category><xsl:value-of select="@category"/></category>
        </ingredient>
    </xsl:template>

    <xsl:template match="tool">
        <tool>
            <name><xsl:value-of select="."/></name>
        </tool>
    </xsl:template>

    <xsl:template match="user">
        <user>
            <name><xsl:value-of select="."/></name>
        </user>
    </xsl:template>

</xsl:stylesheet>
