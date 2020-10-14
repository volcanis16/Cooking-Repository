# README

Application for storing recipes in a searchable environment.

Ruby 2.6.4
Rails 6.0.3.3

Migration:
  Run rails db:migrate or db:schema:load
  Run rails db:seed -app wont run without the seeded rows

Features include:
  User and admin accounts:
    All pages excepting the sign in page are locked behind user authentication.

    Regular users have access to content in the app and can add notes to recipes. They are not allowed to create or edit recipes, accounts or the site options.

    Admins are the only ones who can create or edit accounts and recipes.

    Default admin after database seeding is username: admin password: password. Create a new admin and delete the default one asap.

    Tracking information including number of times logged in and the date/ip of the last 2 logins for each account.

  Recipe creation forms:
    Recipes require a title, ingredients require a name.

    In the recipe creation/editing forms an admin can set:
      Title
      Servings
      An image to represent the recipe
      A rating on a scale of 1-5 with .5 increments
      Any number of ingredients. Using the add ingredient button to create an extra ingredient row.
      A description/instructions
      Notes
      Tags (comma dilineated, Ingredient name can be added to the tags list by clicking on the # button next to the ingredient)
      Categories (comma dilineated)
    
    Upon submission the tags and categories will be checked for new ones and a confirmation box will pop up asking if they are correct. This is to avoid tags with misspellings or forgotten commas.

  Customizable Home page:
    On the home page there are multiple rows of recipes in drag-scroll boxes. Each of these includes 20 random recipes from various tags/categories.

    One box contains recipes from all recipes
    One box contains recipes from a randomly selected category. This category changes every day.
    The rest are set by an Admin.
      This setting is applied to the site and is not per user.
  
  Collapsible Side Navigation Bar & Customizeable Groups:
    The sidebar contains a search bar(more on this later) and collapsible Tag and Category lists.
    Admins can create groups of Categories and Tags that will be displayed here as well.

  Searchability:
    The search bar uses a comma dilineated term based search method. Seach for specific tags and categories is possible by prepending either tag: or cat:. Placing a - before the term will exclude posts with that term.

    For example:
      -tag:flour, tag:egg, cat:breakfast, -irish, pancake

    Will find any recipe:
    Without the tag flour.
    AND with the tag egg.
    AND with the category breakfast.
    AND without irish as a tag, category, or in any part of the title.
    AND with pancake as a tag, category, or in any part of the title

    In the sidebar the + and - symbols next to each category or tag will add that tag or category to the search bar. It is added with the corresponding tag: or cat: with the - symbol adding it in the negative.


    



