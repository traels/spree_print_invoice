Spree::Core::Engine.routes.append do
  namespace :admin do
    match '/orders/:id(.:format)', to: 'orders#show', via: :get
  end
end
