# ONTOP iOS Assignment

Welcome to the ONTOP iOS developer candidate assignment.

Thanks for your interest in the ONTOP Team. You are just a couple of steps away from joining a world-class team of passionate professionals.

In this task, it comes down to presenting your skills, so try to focus on quality rather than quantity of code. We don’t require you to reinvent the wheel, so you can use any library you find suitable. You can also apply any building scripts or software best practices to speed up the development. When working on the project please make use of the version control system (we would like to see the history of commits).

We don't want to occupy too much of your time, so we already prepared a basic project to get going. _Feel free to use it, adapt it, or just remove it and build your own solution_. Our estimation is that it is possible to finish the assignment in about 2-4 hours.

As mentioned, you're not required to stick to the template. Feel free to change it to your liking, or build from scratch. If you do, please motivate your decisions in the final PR. Of course, try to keep your code clean and readable, so if needed create extra types and files where needed.

Please feel free to use either UIKit or SwiftUI, and apply any view architecture, whatever you're most comfortable with.

## Description
Create an app to look up the evolution chain of Pokémon. It's showing a list of Pokémon. For each Pokémon, it has a detail screen showing the evolution chain for this Pokémon species.

Use the public *Poké-API*: https://pokeapi.co

## Requirements
1. Create your solution on a git branch, perform your work there, and finish by creating a PR.
2. List of (paginated) Pokémon species (`v2/pokemon-species`)
    * Replace the FakeRequestHandler by a real request handler doing the networking.
    * Display the species' Name
    * Load the species' image using this pattern: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{species_id}.png`)
      * For simplicity, you can assume that `species_id` equals the index + 1 of the returned list of species.
3. Details screen of species, containing:
    * Name & image of the species
    * Evolution chain with names (& images, optional) (`/v2/evolution-chain/{chain_id}`)
    * You may use the assumption that Pokémon species only evolve into no more than 1 other species
    * For example, Bulbasaur evolves into Ivysaur, Ivysaur evolves into Venusaur, and Venusaur does not evolve. So, for each of these three species the evolution chain would include: Bulbasaur - Ivysaur - Venusaur. On the other hand, Eevee can evolve into any of the following: Vaporeon, Jolteon, Flareon. So for Eevee the following chain would be considered correct: Eevee - Vaporeon.  
4. Write down your motivation for deciding on the tech stack you've used (architecture, dependencies, …)
    * You can put this motivation in the PR description.

## Assumptions
* `species.id == pokemon.id`
* `species.id != chain.id`
* Species evolves into only 1 other species

### Developer Notes
* The use of helper dependencies is ok, but the core should be your own code.
* Use the most recently released version of Swift.
* Focus on iPhone only, but make sure it works properly for all supported device types & orientations.

## What will be assessed?
1. Functionality: the application has the functions described in the job and does not crash. Errors are handled properly *(weight 2)*
2. Quality of code: the code does not contain any design faults, is written in accordance with the conventions and standards, and is easy to read *(weight 3)*
3. Application Architecture: The application can be easily maintained and extended, there are clear layers visible, etc. *(weight 3)*
4. User Experience & UI Design: application is clear and easy to use (but no need to create some super-beautiful graphics, it’s more about the (auto-)layout and chosen components) *(weight 1.5)*
5. Library Selection: Selected 3rd party libraries (if any) should have a reasonable use case, and be of high quality *(weight 0.5)*

## Bonus
Try to approach this like you would to a production application. Let it support typical situations unique to mobile applications, such as lack of network coverage, etc.

If you have some time to spend beyond the assessment requirements, feel free to improve/extend up the app in any way: create an attractive UI, animations, some new functionality, unit tests, etc.

