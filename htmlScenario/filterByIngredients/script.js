function extend(elementClique) {
    console.log("extend");
    var recipe = elementClique.parentElement.children[1];
    console.log(recipe)
    if (recipe.style.display === "block") {
      recipe.style.display = "none";
    } else {
      recipe.style.display = "block";
    }
  }