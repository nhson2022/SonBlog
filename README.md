# SonBlog

## Create New Project
```bash
rails new SonBlog -c sass -j esbuild -d mysql

```
## Update database config
```yml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: localhost
  port: 3306
  username: root
  password: Son@2023
  socket: /var/run/mysqld/mysqld.sock

development:
  <<: *default
  database: sonblog_development

test:
  <<: *default
  database: sonblog_test

```

## Create database
```bash
rails db:create
```

## Setup bootstrap, jquery and select2
```bash
yarn add bootstrap jquery @popperjs/core select2
```

**Update sass config app/assets/stylesheets/application.sass.scss**
```scss
@import "bootstrap/dist/css/bootstrap";
@import "select2/dist/css/select2";
```

**Update app/javascript/application.js to add jquery and select2**
```js
// Setup jquery
import jquery from 'jquery';
window.jQuery = jquery;
window.$ = jquery;

import Select2 from "select2"
window.Select2 = Select2
Select2()

// load select2
document.addEventListener('turbo:load', () => {
  // apply to all elements that have class .select2
  $('.select2').select2()
})
```

## Run App
```bash
./bin/dev
```
Listening on http://127.0.0.1:3000

## Setup Devise
```bash
bundle add devise
rails generate devise:install
rails g devise:views

rails generate devise User
rails db:migrate
```

**Update config/environments/development.rb**
```rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

**Update app/views/layouts/application.html.erb**
```html
<div class="container">
  <% if notice.present? %>
    <div class="alert alert-primary mt-4" role="alert">
      <%= notice %>
    </div>
  <% end %>

  <% if alert.present? %>
    <div class="alert alert-danger mt-4" role="alert">
      <%= alert %>
    </div>
  <% end %>

  <%= yield %>
</div>
```

**Setup Active Storage**
```bash
bin/rails active_storage:install
bin/rails db:migrate
```

**Setup Action Text**
```bash
bin/rails action_text:install
bin/rails db:migrate
```

## Create controller pages home and info
```bash
rails g controller pages home
```

## Create Category model, controller, view (scaffold)
```bash
rails g scaffold Category name description:text
```

## Create Article model, controller, view (scaffold)
```bash
rails g scaffold Article title user:references active:boolean
```
**Update migration to change default value of the active field**
db/migrate/20230320131803_create_articles.rb
```rb
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
```

**Add hidden field user_id to app/views/articles/_form.html.erb**
```html
<%= form_with(model: article) do |form| %>
  <!-- add hidden_field user_id here -->
  <%= form.hidden_field :user_id, value: current_user&.id %>
  <% if article.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(article.errors.count, "error") %> prohibited this article from being saved:</h2>
      <ul>
        <% article.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
  <div class="my-2">
    <%= form.label :title, style: "display: block" %>
    <%= form.text_field :title, class: "form-control" %>
  </div>
  <div class="my-2">
    <%= form.label :content, style: "display: block" %>
    <%= form.rich_text_area :content, class: "form-control" %>
  </div>
  <div class="my-2">
    <%= form.label :category_id, style: "display: block" %>
    <%= form.select :category_id, options_for_select(category_select_options, form.object.category&.id), { include_blank: "Select category"}, { class: 'form-select select2' } %>
  </div>
  <div class="my-2">
    <div class="form-check">
      <%= form.check_box :active, class: "form-check-input", class: "form-check-input" %>
      <%= form.label :active, class: "form-check-label" %>
    </div>
  </div>
  <div class="my-2">
    <%= form.submit class: "btn btn-primary" %>
  </div>
<% end %>

```

**Create category_select_options helper method in app/helpers/application_helper.rb**
```rb
# app/helpers/application_helper.rb
def category_select_options
  Category.all.map { |c| [c.name, c.id] }
end
```

**Migration database**
```bash
rails db:migrate
```

## Setup gem will_paginate for pagination
```bash
# https://github.com/mislav/will_paginate
bundle add will_paginate
```

**Will Paginate link renderer bootstrap styles**
```bash
bundle add will_paginate-bootstrap-style
```

## Update bootstrap styles
```
My hobbies
```

## Use gem faker to generate test data
```bash
bundle add faker
```

## Create seed data in db/seeds.rb
```rb
# db/seeds.rb

user = User.create(email: "son@example.com", password: "demo", password_confirmation: "demo")
30.times.each do |cindex|
  cate = Category.create(name: Faker::Food.ingredient, description: Faker::Quote.famous_last_words)
  puts "create new category: #{cate.name}"
  30.times.each do |aindex|
    article = Article.create(title: Faker::Quote.most_interesting_man_in_the_world, user: user, category: cate, content: Faker::Lorem.paragraphs(number: 10).join, active: true)
    puts "created article #{article.id} - #{article.title}"
  end
end
```
**To re-create database**
```bash
rails db:drop db:create db:migrate
rails db:seed
```

## Custom Turbo Confirm Modals with Hotwire in Rails
**Update layout application.html.erb**
```html
<!-- app/views/layouts/application.html.erb -->
<dialog id="turbo-confirm">
  <form method="dialog">
    <p>Are you sure?</p>
    <div>
      <button value="cancel">Cancel</button>
      <button value="confirm">Confirm</button>
    </div>
  </form>
</dialog>
```

**Update application.js**
```js
// app/javascript/application.js
Turbo.setConfirmMethod((message, element) => {
  console.log(message, element)
  let dialog = document.getElementById("turbo-confirm")
  dialog.querySelector("p").textContent = message
  dialog.showModal()

  return new Promise((resolve, reject) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue == "confirm")
    }, { once: true })
  })
})
```

## Implement search articles
**Create this static method in article model**
```rb
# app/models/article.rb

def self.search(params)
  if params[:q].present?
    return includes(:user).with_rich_text_content_and_embeds
              .where("LOWER(title) LIKE LOWER(?)", "%#{params[:q].to_s.squish}%")
              .order(id: :desc)
              .paginate(page: params[:page] || 1, per_page: 10)
  end

  includes(:user).with_rich_text_content_and_embeds
    .order(id: :desc)
    .paginate(page: params[:page] || 1, per_page: 10)
end
```

## Verify authentication on article and category controller
**Edit app/controllers/articles_controller.rb**
```rb
class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: %i[ new edit create update destroy ]
  ...
end
```
**Edit app/controllers/categories_controller.rb**
```rb
class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[ new edit create update destroy ]
  ...
end
```