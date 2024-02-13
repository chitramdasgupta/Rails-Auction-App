# Create Buyers
User.create!(email: 'buyer1@email.com', password: 'password', password_confirmation: 'password',
             user_type: 'buyer')
User.create!(email: 'buyer2@email.com', password: 'password', password_confirmation: 'password',
             user_type: 'buyer')
User.create!(email: 'buyer3@email.com', password: 'password', password_confirmation: 'password',
             user_type: 'buyer')

# Create Sellers
seller1 = User.create!(email: 'seller1@email.com', password: 'password', password_confirmation: 'password',
                       user_type: 'seller')
seller2 = User.create!(email: 'seller2@email.com', password: 'password', password_confirmation: 'password',
                       user_type: 'seller')

# Create Products associated with sellers
Product.create!(name: 'Product 1', description: 'Description of product 1', user: seller1)
Product.create!(name: 'Product 2', description: 'Description of product 2', user: seller1)
Product.create!(name: 'Product 3', description: 'Description of product 3', user: seller1)
Product.create!(name: 'Product 4', description: 'Description of product 4', user: seller2)
Product.create!(name: 'Product 5', description: 'Description of product 5', user: seller2)
