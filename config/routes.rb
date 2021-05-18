Rails.application.routes.draw do
  namescape :api do
    resouces :users, only: %i[create]
    resouce :session, only: %i[create destroy]
  end
end
