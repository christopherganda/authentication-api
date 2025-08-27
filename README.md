# Authentication API
## How to use
### 1. Install RVM
Follow the installation guide at [RVM Install](https://rvm.io/rvm/install).

### 2. Install Ruby on Rails
Use RVM to install the required Ruby version and then install Rails:
```bash
rvm install ruby-3.0.0
rvm use ruby-3.0.0 --default
gem install rails
```

### 3. Run Migration Commands
Prepare the database:
```bash
rails db:create
rails db:migrate
```

### 4. Run the Server
Start the Rails server:
```bash
rails server
```

### 5. Setup test db
Prepare the database:
```bash
RAILS_ENV=test rails db:drop
RAILS_ENV=test rails db:create
```

Navigate to `http://localhost:3000` to access the application.

