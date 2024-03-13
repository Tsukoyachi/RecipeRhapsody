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
        if(usersTree):
            for child in usersTree:
                userList.append({"id": child.attrib['userId'], "name": child.text})
        return userList

    def getTools(self, toolsTree):
        toolList = []
        if(toolsTree):
            for tool in toolsTree:
                toolList.append({"id": tool.attrib['toolId']})
        return toolList

    def getIngredients(self, ingredientsTree):
        ingredientList = []
        if(ingredientsTree):
            for child in ingredientsTree:
                ingredientList.append({"id": child.attrib['ingredientId'], "category": child.attrib['category'], "season": child.attrib['season'], "name": child.text})
        return ingredientList
    
    def getRecipes(self, recipesTree):
        recipeList = []
        if(not(recipesTree)):
            return recipeList
        for child in recipesTree:
            recipe = {}
            recipe["name"]= child.find('name').text
            recipe["stepsCount"]= len(child.find('steps'))

            ingredientList = []
            for ingredient in child.find('ingredients'):
                ingredientList.append({"id": ingredient.attrib['ingredientId'], "quantity": ingredient.find('quantity').text})

            toolList = []
            toolsTree = child.find('tools')
            if(toolsTree):
                for tool in child.find('tools'):
                    toolList.append({"id": tool.attrib['toolId']})

            allergenList = []
            allergensTree = child.find('allergens')
            if(allergensTree):
                for allergen in allergensTree:
                    allergenList.append({"id": allergen.attrib['allergenId']})
            
            userRatingList = []
            userRatingsTree = child.find('userRatings')
            if(userRatingsTree):
                for userRating in child.find('userRatings'):
                    userRatingList.append({"id": userRating.attrib['userId'], "grade": userRating.attrib['grade'], "comment":userRating.text})

            recipe["ingredients"]= ingredientList
            recipe["tools"]= toolList
            recipe["allergens"]= allergenList
            recipe["userRatings"]= userRatingList
            recipeList.append(recipe)
        
        return recipeList

        
        
        

class RecipesStatistics:
    def __init__(self, xmlParser):
        self.__xmlParser = xmlParser
    
    def printUsersInfo(self):
        print(f"\n--------- Users informations ---------")
        userCount = len(self.__xmlParser.users)
        print(f"Number of users : {userCount}")
    
    def printToolsInfo(self):
        print(f"\n--------- Tools informations ---------")
        toolsCount = len(self.__xmlParser.tools)
        print(f"Number of tools : {toolsCount}")
    
    def printIngredientsInfo(self):
        print(f"\n--------- Ingredients informations ---------")
        ingredients = self.__xmlParser.ingredients
        ingredientsCount = len(ingredients)
        print(f"Number of ingredients : {ingredientsCount}")

        ingredientsByCategories = {}
        for ingredient in ingredients:
            if(ingredient["category"] in ingredientsByCategories.keys()):
                ingredientsByCategories[ingredient["category"]] +=1
            else:
                ingredientsByCategories[ingredient["category"]] = 1
        for category in ingredientsByCategories.keys():
            print(f"    Number of {category} : {ingredientsByCategories[category]}")

    def printRecipesInfo(self):
        print(f"\n--------- Recipes informations ---------")
        recipes = self.__xmlParser.recipes
        recipesCount = len(recipes)
        print(f"Number of recipes : {recipesCount}")

        stepsCount = 0
        for recipe in recipes:
            stepsCount += recipe["stepsCount"]
        print(f"Average number of steps : {stepsCount/recipesCount}")

        ingredientsCount = 0
        for recipe in recipes:
            ingredientsCount += len(recipe["ingredients"])
        print(f"Average number of ingredients : {round(ingredientsCount/recipesCount, 2)}")

        ratesCount = 0
        rates = 0
        for recipe in recipes:
            ratesCount += len(recipe["userRatings"])
            for rate in recipe["userRatings"]:
                rates += float(rate["grade"])
        print(f"Average number of rates : {round(ratesCount/recipesCount, 2)}")
        print(f"Average rate : {round(rates/ratesCount, 2)}")
        print("\n")

        


    
if __name__ == '__main__':
    xmlParser = XmlParser(sys.argv[1])
    recipesStatistics = RecipesStatistics(xmlParser)
    recipesStatistics.printUsersInfo()
    recipesStatistics.printToolsInfo()
    recipesStatistics.printIngredientsInfo()
    recipesStatistics.printRecipesInfo()