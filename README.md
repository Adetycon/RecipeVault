# RecipeVault

A decentralized culinary recipe sharing platform built on the Stacks blockchain. Share your favorite recipes, discover new cuisines, and build a community-driven cookbook.

## Features

- **Recipe Sharing**: Publish your culinary creations with detailed instructions
- **Cuisine Categories**: Organize recipes by cuisine type (Italian, Asian, Mexican, French, Indian, American)
- **Difficulty Levels**: Rate recipes from Beginner to Expert
- **Prep Time Tracking**: Include preparation time for better planning
- **Decentralized Storage**: All recipes stored securely on the blockchain

## Smart Contract Functions

### Public Functions
- `share-recipe`: Publish a new recipe to the platform
- `remove-recipe`: Remove your own recipe from active listings

### Read-Only Functions
- `get-recipe`: Retrieve recipe details by ID
- `get-chef`: Get the chef (creator) of a specific recipe

## Getting Started

1. Clone the repository
2. Install Clarinet
3. Run `clarinet check` to verify contract validity
4. Deploy to Stacks testnet or mainnet

## License

MIT License
