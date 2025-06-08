#!/bin/bash

echo "🔧 starting Psychonnect setup..."

REQUIRED_RUBY="3.4.1"
CURRENT_RUBY=$(ruby -v | cut -d " " -f2 | cut -dp -f1)

# 1. Ruby
if ! ruby -e "exit Gem::Version.new('$CURRENT_RUBY') >= Gem::Version.new('$REQUIRED_RUBY') ? 0 : 1"; then
    echo "⚠️  Warning: This project requires Ruby $REQUIRED_RUBY or higher"
    echo "    Current detected version: $CURRENT_RUBY"
    echo "    Use rbenv or rvm to change version."
fi



# 2. Bundler
if ! gem list bundler -i > /dev/null 2>&1
then
    echo "📦 Bundler not found encontrado. Installing..."
    gem install bundler
fi

# 3. Gems
echo "📦 Installing gems using bundler..."
bundle install

# 4. Copies .env.example if needed
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        echo "📝 Creating .env from .env.example..."
        cp .env.example .env
    else
        echo "⚠️ Warning: .env.example not found. Please create .env with your credentials..."
    fi
fi

# 5. Database
echo "🛠 Creating and migrating database..."
bin/rails db:prepare

# 6. Done
echo "✅ Setup finished! Now you may run the server with:"
echo ""
echo "    bin/rails server"
echo ""
