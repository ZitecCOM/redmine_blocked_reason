resources :blocked_reasons
resources :blocked_reason_types, except: [:index, :show]
get 'settings/plugin/redmine_blocked_reason', to: 'blocked_reason_types#plugin',
  as: :blocked_reason_settings
