
# from http://pastebin.com/bzvKG0VB

FactoryGirl.define do
  factory :movie do
    title 'A Fake Title' # default values
    rating 'PG'
    director 'Spielberg'
    release_date { 10.years.ago }
  end
end