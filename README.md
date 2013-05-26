# PageFragments

Page Fragments is gem for Ruby On Rails.
PageFragments allow you to store snippets of pages in the database and edit them in the admin application.

## Installation

Add this line to your application's Gemfile:

    gem "page_fragments"

First, execute

    $ rails generate page_fragments:install

this create config/page_fragments.rb when you write you templates

```ruby
PageFragment.templates do
  #fragment :fragment_type, :fragment_key

  fragment :string, :header
  fragment :text, :about
end
```

After edit templates config you should execute 'rake pf:init'. This create templates in your database.

And this generator create migration for PageFragment model.
Now we have to perform

    $ rake db:migrate

PageFragments have standard controller and views. You can using own controller inherited from `PageFragments::PageFragmentsController`.
After this you should to edit routes.

It will copy all views to your application:

    $ rails generate page_fragments:views

## Usage

In you view:

```erb
<%= render_page_fragment :key_of_fragment %>
```

## Authors

Promakh Alexandr: s-promakh@ya.ru
MyStand: http://mystand.ru/

MIT License. Copyright 2013 Promakh Alexandr.
