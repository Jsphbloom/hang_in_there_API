require "rails_helper"
require "simplecov"
SimpleCov.start

describe "hang_in_there_API", type: :request do
  before(:all) do
    Poster.create(
    name: "REGRET",
    description: "Hard work rarely pays off.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    Poster.create(
    name: "WOE",
    description: "Life is an endless toil.",
    price: 20.00,
    year: 2016,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    Poster.create(
    name: "MISERY",
    description: "Why me God?",
    price: 9.00,
    year: 2008,
    vintage: false,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  end

  it "sends a list of posters" do
    get "/api/v1/posters"

    expect(response).to be_successful

    poster_data = JSON.parse(response.body, symbolize_names: true)
    expect(poster_data.count).to eq(2)
    expect(poster_data[:data].count).to eq(3)
    poster_data[:data].each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_a(Integer)
      expect(poster).to have_key(:type)
      expect(poster[:type]).to be_a(String)
      expect(poster).to have_key(:attributes)
      expect(poster[:attributes]).to be_a(Hash)
      expect(poster[:attributes]).to have_key(:name)
      expect(poster[:attributes][:name]).to be_a(String)
      expect(poster[:attributes]).to have_key(:description)
      expect(poster[:attributes][:description]).to be_a(String)
      expect(poster[:attributes]).to have_key(:price)
      expect(poster[:attributes][:price]).to be_a(Float)
      expect(poster[:attributes]).to have_key(:year)
      expect(poster[:attributes][:year]).to be_a(Integer)
      expect(poster[:attributes]).to have_key(:vintage)
      expect([true, false]).to include(poster[:attributes][:vintage])   #Weird way to write this test...maybe refactor later
      expect(poster[:attributes]).to have_key(:img_url)
      expect(poster[:attributes][:img_url]).to be_a(String)
    end
  end

  it "creates a new poster and returns appropriate response" do
    incoming_valid_parameters = {
      "name": "DEFEAT",
      "description": "It's too late to start now.",
      "price": 35.00,
      "year": 2023,
      "vintage": false,
      "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: incoming_valid_parameters)

    #Check for database being updated correctly.  Anything additional?
    #Query DB:
    newest_poster = Poster.last
    newest_poster = Poster.order(created_at: :desc).limit(1)[0]

    expect(response).to be_successful
    #Also check the actual response (code + content)
    expect(newest_poster.name).to eq(incoming_valid_parameters[:name])
    expect(newest_poster.description).to eq(incoming_valid_parameters[:description])
    expect(newest_poster.price).to eq(incoming_valid_parameters[:price])
    expect(newest_poster.year).to eq(incoming_valid_parameters[:year])
    expect(newest_poster.vintage).to eq(incoming_valid_parameters[:vintage])
    expect(newest_poster.img_url).to eq(incoming_valid_parameters[:img_url])

    #Later: also test invalid API data?

  end

  it "deletes a specified poster from the database" do
    #Create a temporary poster just for verifying deletion later
    temp_poster = Poster.create(name: "APATHY", description: "I wouldn't be so apathetic if I weren't so lethargic")

    
    expect(Poster.count).to eq(4)   #Added one record on top of the three sample posters.  Might try the 'change.by' later...
    
    delete "/api/v1/posters/#{temp_poster.id}"
    
    expect(response).to be_successful
    expect(Poster.count).to eq(3)
    expect{ (Poster.find(temp_poster.id)) }.to raise_error(ActiveRecord::RecordNotFound)      #WHY does this need {}'s to run correctly?  Because of how errors are evaluated?

    #Later: could try to delete one of the earlier added ones too to verify it was removed, and also try to delete an nonexistent poster

  end

  it 'can fetch a single poster' do
    get "/api/v1/posters/1"

    expect(response).to be_successful

    poster_data = JSON.parse(response.body, symbolize_names: true)

    expect(poster_data.count).to eq(2)
    expect(poster_data[:data].count).to eq(3)
    expect(poster_data[:data]).to have_key(:type)
    expect(poster_data[:data][:id]).to be_a(Integer)
    expect(poster_data[:data][:type]).to be_a(String)
    expect(poster_data[:data]).to include(:attributes)
    expect(poster_data[:data][:attributes]).to be_a(Hash)
    expect(poster_data[:data][:attributes]).to have_key(:name)
    expect(poster_data[:data][:attributes][:name]).to be_a(String)
    expect(poster_data[:data][:attributes]).to have_key(:description)
    expect(poster_data[:data][:attributes][:description]).to be_a(String)
    expect(poster_data[:data][:attributes]).to have_key(:price)
    expect(poster_data[:data][:attributes][:price]).to be_a(Float)
    expect(poster_data[:data][:attributes]).to have_key(:year)
    expect(poster_data[:data][:attributes][:year]).to be_a(Integer)
    expect(poster_data[:data][:attributes]).to have_key(:vintage)
    expect([true, false]).to include(poster_data[:data][:attributes][:vintage])   #Weird way to write this test...maybe refactor later
    expect(poster_data[:data][:attributes]).to have_key(:img_url)
    expect(poster_data[:data][:attributes][:img_url]).to be_a(String)
  end

  it 'can update a poster' do
    ogposter = Poster.create!(
    name: "TEST",
    description: "This is a test..",
    price: 10.00,
    year: 2,
    vintage: false,
    img_url:  "nil"
    )
    id = ogposter.id
    previous_name = Poster.last.name
    updated_poster_params = { 
      name: "TEST II",
      description: "This is another test." 
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate(poster: updated_poster_params)
    poster = Poster.find_by(id: id)
    expect(response).to be_successful
    expect(poster.name).to_not eq(previous_name)
    expect(poster.name).to eq("TEST II")
    
  end

  it 'can adjust results using query parameters' do

    get "/api/v1/posters?sort=asc"
    expect(response).to be_successful

    poster_data = JSON.parse(response.body, symbolize_names: true)

    expect(poster_data.count).to eq(2)
    expect(poster_data[:data].count).to eq(3)
    expect(poster_data[:data][0][:attributes][:price]).to be < poster_data[:data][1][:attributes][:price]
    expect(poster_data[:data][0][:attributes][:price]).to be < poster_data[:data][2][:attributes][:price]
    expect(poster_data[:data][1][:attributes][:price]).to be < poster_data[:data][2][:attributes][:price]

    get "/api/v1/posters?sort=desc"
    expect(response).to be_successful

    poster_data = JSON.parse(response.body, symbolize_names: true)

    expect(poster_data.count).to eq(2)
    expect(poster_data[:data].count).to eq(3)
    expect(poster_data[:data][0][:attributes][:price]).to be > poster_data[:data][1][:attributes][:price]
    expect(poster_data[:data][0][:attributes][:price]).to be > poster_data[:data][2][:attributes][:price]
    expect(poster_data[:data][1][:attributes][:price]).to be > poster_data[:data][2][:attributes][:price]
  end

  it 'can sort created posters' do
    incoming_valid_parameters = {
      "name": "CHEAPEST",
      "description": "Should be the first element.",
      "price": 1.00,
      "year": 2023,
      "vintage": false,
      "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: incoming_valid_parameters)
    expect(response).to be_successful

    incoming_valid_parameters = {
      "name": "PRICIEST",
      "description": "It's too late to start now.",
      "price": 20000.00,
      "year": 2023,
      "vintage": false,
      "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: incoming_valid_parameters)
    expect(response).to be_successful

    get "/api/v1/posters?sort=asc"
    expect(response).to be_successful
    poster_data = JSON.parse(response.body, symbolize_names: true)

    expect(poster_data[:data][0][:attributes][:price]).to be < poster_data[:data][1][:attributes][:price]
    expect(poster_data[:data][0][:attributes][:price]).to be < poster_data[:data][2][:attributes][:price]
    expect(poster_data[:data][0][:attributes][:price]).to be < poster_data[:data][4][:attributes][:price]

    expect(poster_data[:data][1][:attributes][:price]).to be < poster_data[:data][4][:attributes][:price]
    expect(poster_data[:data][2][:attributes][:price]).to be < poster_data[:data][4][:attributes][:price]
    expect(poster_data[:data][3][:attributes][:price]).to be < poster_data[:data][4][:attributes][:price]

    get "/api/v1/posters?sort=desc"
    expect(response).to be_successful

    poster_data = JSON.parse(response.body, symbolize_names: true)

    expect(poster_data[:data][0][:attributes][:price]).to be > poster_data[:data][1][:attributes][:price]
    expect(poster_data[:data][0][:attributes][:price]).to be > poster_data[:data][2][:attributes][:price]
    expect(poster_data[:data][0][:attributes][:price]).to be > poster_data[:data][4][:attributes][:price]

    expect(poster_data[:data][1][:attributes][:price]).to be > poster_data[:data][4][:attributes][:price]
    expect(poster_data[:data][2][:attributes][:price]).to be > poster_data[:data][4][:attributes][:price]
    expect(poster_data[:data][3][:attributes][:price]).to be > poster_data[:data][4][:attributes][:price]
  end

  it 'can sort updated posters' do

    get "/api/v1/posters?sort=asc"
    expect(response).to be_successful

    poster_data = JSON.parse(response.body, symbolize_names: true)

    expect(poster_data.count).to eq(2)
    expect(poster_data[:data].count).to eq(3)
    expect(poster_data[:data][0][:attributes][:price]).to eq(9.0)

    updated_poster_params = { 
      description: "updated cheapest price",
      price: 0.01,
      id: 3
    }
    headers = {"CONTENT_TYPE" => "application/json"}
# binding.pry
    patch "/api/v1/posters/1", headers: headers, params: JSON.generate(poster: updated_poster_params)
    #why is this not updating the poster?
    expect(response).to be_successful
    get "/api/v1/posters?sort=asc"
    expect(response).to be_successful
    poster_data = JSON.parse(response.body, symbolize_names: true)
# binding.pry
    expect(poster_data[:data][0][:attributes][:price]).to eq(0.01)
  end
end