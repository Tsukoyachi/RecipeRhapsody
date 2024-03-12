function extend(elementClique) {
    console.log("extend");
    var recipe = elementClique.parentElement.children[1];
    var imageHeader = elementClique.children[1];
    console.log(recipe)
    if (recipe.style.display === "block") {
      recipe.style.display = "none";
      imageHeader.style.display = "block";
    } else {
      recipe.style.display = "block";
      imageHeader.style.display= "none";
    }
  }