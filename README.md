# Dm Unibo Common gem

Dm Unibo Common is a Ruby gem (actually a Rails Engine) 
with code and configurations common to my ruby projects.

# Installation

Check to have this gems in Gemfile:

```
gem 'dm_unibo_user_search', git: 'https://github.com/donapieppo/dm_unibo_user_search.git'
gem 'dm_unibo_common',      git: 'https://github.com/donapieppo/dm_unibo_common.git', branch: 'turbo'

gem "cssbundling-rails", "~> 1.1"
gem "sprockets-rails"
gem "jsbundling-rails"
```

We use asbuild and postcss and so run

```bash
./bin/rails css:install:postcss
./bin/rails javascript:install:esbuild
```

(if you generate a new app use `rails new pippo -j esbuild --css postcss`).

Add `"dm_unibo_common": "donapieppo/dm_unibo_common.git"` in 
package.json.

Create a file

```bash
touch ./config/dm_unibo_common.yml
```

like

```yaml
production:
  omniauth_provider: :google_oauth2
  host:              example.com
  smtp_address:      mailhost.example.com
  smtp_domain:       example.com
  support_mail:      supportoweb@example.com
  logout_link:       https://idp.example.comt/adfs/ls/?wa=wsignout1.0
  login_icon:        dm_unibo_common/ssologo18x18.png
  logout_icon:       dm_unibo_common/ssologo18x18.png

development:
  omniauth_provider: :shibboleth
  host:              tester.example.com
  smtp_address:      mailhost.example.com
  smtp_domain:       example.com
  support_mail:      supportoweb@example.com
  logout_link:       https://idptest.example.com/adfs/ls/?wa=wsignout1.0
  login_icon:        dm_unibo_common/ssologo18x18.png
  logout_icon:       dm_unibo_common/ssologo18x18.png
```

and load in `config/application.rb` with

```ruby
config.dm_unibo_common = ActiveSupport::HashWithIndifferentAccess.new config_for(:dm_unibo_common)
```
DmUniboCommon implements google_oauth2 and shibboleth authentication.

# How to use in your rails project

In your app define User model

```ruby
class User < ApplicationRecord 
  include DmUniboCommon::User
```

Organization model 

```ruby
class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :permissions, class_name: "DmUniboCommon::Permission"
```

```ruby
class Authorization
  include DmUniboCommon::Authorization

  _authlevels = { 
    read:   1, 
    manage: 2, 
    pippo: 3
  }

  configure_authlevels(_authlevels)
  DmUniboCommon::OrganizationPolicy.configure_authlevels(_authlevels)
```

Your ApplicationController has to be a subclass of DmUniboCommon::ApplicationController
```ruby
class ApplicationController < DmUniboCommon::ApplicationController
```

Then define routes in base of organization (see below).

```ruby
Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common"

  scope ":__org__" do
    .......
  end
```

# DmUniboCommon helpers

DmUniboCommon provides some helpers (see that comes from 
`lib/dm_unibo_common/controllers/helpers.rb`).

When you define ApplicationController as subclass of DmUniboCommon::ApplicationController
you get all the new helpers, [Pundit](https://github.com/varvet/pundit) authorization system 
and a list of the following default `before_actions`:

**set_current_user**

Sets the `current_user`. `DmUniboCommon` provides also the helper `current_user`

**update_authorization**

If there is a current_user it gets the DmUniboCommon::CurrentUser methods
(see `app/models/dm_unibo_common/current_user.rb`, used as
`current_user.extend(DmUniboCommon::CurrentUser`). 

This means that the `current_user` (a `User` istance usually) gets the 
authorization attribute that carries the current authorization of the user in 
application (see below)

**set_current_organization**

Sets the `current_organization`.
DmUniboCommon provides also the helper `current_organization`.

# current_organization

Applications that uses DmUniboCommon provides usually the
same application/user experience to different organziations
(or administrative units).

For example in unibo organizations can be the different Departments
or different administration units.

Every organization has a code in the database (and a name and description).

From the url

https://example.com/math/posts

params[:__org__] is 'math' and your controller/action is posts/index.

This is defined in `config/routes.rb` as seen before.


# DmUniboCommon::Authorization

`current_user` has authorization in the form of an instance of

```
class DmUniboCommon::Authorization
```

(under the curtains current_user.authorization = DmUniboCommon::Authorization.new(ip, self))

DmUniboCommon::Authorization provides the next methods:

    - has_authorization? -> true/false (has some organziation with some level of access?)
    - multi_organizations? -> true/false (has more than one organization with some level of access?)
    - organizations -> array of organizations where user has some level of access 
    - authlevel(org) -> int (level of authorization in organization)

# DmUniboCommon::Modal

in `app/javascript/controllers/index.js` add 

```javascript
import { TurboModalController } from "dm_unibo_common"
application.register("turbo-modal", TurboModalController)
```

and in `app/views/layouts/application.html.erb` 

```erb
<%= turbo_frame_tag "modal" %>
```

When you want to link to a modal content

```erb
<%= link_to article_path(article, modal: 1), data: { turbo_frame: :modal } %>  
```

and in `app/views/articles/show.html.erb`

```erb
<%= render DmUniboCommon::ModalComponent.new(title: @article.name) do %>
...
<% end %>
```
