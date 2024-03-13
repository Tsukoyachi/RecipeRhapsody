import xml.etree.ElementTree as ET
import sys

class XmlParser:

    def __init__(self, filePath):
        self.__xmlroot = ET.parse(filePath).getroot()
        
        self.users = self.getUsers(self.__xmlroot.find('users'))
        self.tools = self.getTools(self.__xmlroot.find('tools'))
        self.ingredients = self.getIngredients(self.__xmlroot.find('ingredients'))
        self.recipes = self.getRecipes(self.__xmlroot.find('recipes'))
    


    def getUsers(self, usersTree):
        userList = []
        for child in usersTree:
            userList.append({"id": child.attrib['userId'], "name": child.text})
        return userList

    def getTools(self, toolsTree):
        toolList = []
        for child in toolsTree:
            toolList.append({"id": child.attrib['toolId'], "name": child.text})
        return toolList

    def getIngredients(self, ingredientsTree):
        ingredientList = []
        for child in ingredientsTree:
            ingredientList.append({"id": child.attrib['ingredientId'], "category": child.attrib['category'], "season": child.attrib['season'], "name": child.text})
        return ingredientList
    
    def getRecipes(self, recipesTree):
        recipeList = []
        
        for child in recipesTree:
            recipe = {}
            recipe["name"]= child.find('name').text
            recipe["stepsCount"]= len(child.find('steps'))

            ingredientList = []
            for ingredient in child.find('ingredients'):
                ingredientList.append({"id": ingredient.attrib['ingredientId'], "quantity": ingredient.find('quantity').text})

            toolList = []
            for tool in child.find('tools'):
                toolList.append({"id": tool.attrib['toolId']})

            allergenList = []
            if(child.find('allergens')):
                for allergen in child.find('allergens'):
                    allergenList.append({"id": allergen.attrib['allergenId']})
            
            userRatingList = []
            for userRating in child.find('userRatings'):
                userRatingList.append({"id": userRating.attrib['userId'], "grade": userRating.attrib['grade'], "comment":userRating.text})

            recipe["ingredients"]= ingredientList
            recipe["tools"]= toolList
            recipe["allergens"]= allergenList
            recipe["userRatings"]= userRatingList
            recipeList.append(recipe)
        
        return recipeList

        
        
        

class RecipesFilter:
    def __init__(self, xmlParser):   
        self.__recipes = xmlParser.recipes
        self.__ingredients = xmlParser.ingredients

    def filterByIngredients(self, ingredients):
        matchingRecipes = []
        for recipe in self.__recipes:
            ingredientsCopy = ingredients.copy()
            for ingredient in recipe["ingredients"]:
                ingredientId = ingredient['id']
                ingredientName = self.getMatchingDictInList("id", ingredientId)["name"]
                
                if ingredientName in ingredientsCopy: ingredientsCopy.remove(ingredientName)
            
            if len(ingredientsCopy) == 0:
                matchingRecipes.append(recipe)
        if(len(matchingRecipes) > 0):
            self.printRecipes(matchingRecipes)

    def printRecipes(self, recipes):
        print("Matching recipes : ")
        for recipe in recipes:
            print(f"- {recipe['name']}")


    def getMatchingDictInList(self, key, value):
        for element in self.__ingredients:
            if(element[key]==value):
                return element
        

    

    
if __name__ == '__main__':
    xmlParser = XmlParser(sys.argv[1])
    recipesFilter = RecipesFilter(xmlParser)

    ingredients = []
    for i in range(2, len(sys.argv)):
        ingredients.append(sys.argv[i])

    recipesFilter.filterByIngredients(ingredients)
