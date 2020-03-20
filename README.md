# Dm Unibo Common gem

Dm Unibo Common is a Ruby gem (actually a Rails Engine) 
with code and configurations common to my ruby projects.

# Installation

```bash
$ git clone https://github.com/donapieppo/dm_unibo_common.git
$ cd dm_unibo_common
$ rake install 
```

# Configuration

When you add 

```
gem 'dm_unibo_common'
```

to the Gemfile of your project, you also have
to create a file
```bash
/home/rails/got/config/dm_unibo_common.yml
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
  logo_page:         http://www.example.com
  logo_image:        dm_unibo_common/unibo.png

development:
  omniauth_provider: :shibboleth
  host:              tester.example.com
  smtp_address:      mailhost.example.com
  smtp_domain:       example.com
  support_mail:      supportoweb@example.com
  logout_link:       https://idptest.example.com/adfs/ls/?wa=wsignout1.0
  login_icon:        dm_unibo_common/ssologo18x18.png
  logout_icon:       dm_unibo_common/ssologo18x18.png
  logo_page:         http://www.example.com
  logo_image:        dm_unibo_common/unibo.png
```

and load in `config/application.rb` with

```ruby
config.dm_unibo_common = ActiveSupport::HashWithIndifferentAccess.new config_for(:dm_unibo_common)
```

DmUniboCommon implements google_oauth2 and shibboleth authentication.

# How to use in your rails project

In your app

```ruby
class User < ApplicationRecord 
  include DmUniboCommon::User
```

```ruby
class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :permissions, class_name: "DmUniboCommon::Permission"
```

User ha authorizations that comes from 

```
class DmUniboCommon::Authorization
```

and are configured in ApplicationController with update_current_user_authlevels

```ruby
 before_action :log_current_user, :set_locale, :set_organization, :update_current_user_authlevels
```

(under the curtains current_user.authorization = DmUniboCommon::Authorization.new(ip, self))

DmUniboCommon::Authorization dives the next methods:


    - has_authorization? -> true/false (has some organziation with some level of access?)
    - multi_organizations? -> true/false (has more than one organization with some level of access?)
    - organizations -> array of organizations where user has some level of access 
    - authlevel(org) -> int (level of authorization in organization)
    -  









