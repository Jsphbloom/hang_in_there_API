require "rails_helper"

describe "hang_in_there_API", type: :request do
  before(:each) do
    Poster.create(name: "REGRET",
    description: "Hard work rarely pays off.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    Poster.create(name: "WOE",
    description: "Life is an endless toil.",
    price: 20.00,
    year: 2016,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    Poster.create(name: "MISERY",
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
    expect(poster_data.count).to eq(1)
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

  it 'can fetch a single poster' do
    get "/api/v1/posters?1"

    expect(response).to be_successful

    poster_data = JSON.parse(response.body, symbolize_names: true)

    expect(poster_data.count).to eq(1)
    expect(poster_data[:data].count).to eq(3)
    expect(poster_data[:data].first).to have_key(:type)
    expect(poster_data[:data].first[:id]).to be_a(Integer)
    expect(poster_data[:data].first[:type]).to be_a(String)
    expect(poster_data[:data].first).to include(:attributes)
    expect(poster_data[:data].first[:attributes]).to be_a(Hash)
    expect(poster_data[:data].first[:attributes]).to have_key(:name)
    expect(poster_data[:data].first[:attributes][:name]).to be_a(String)
    expect(poster_data[:data].first[:attributes]).to have_key(:description)
    expect(poster_data[:data].first[:attributes][:description]).to be_a(String)
    expect(poster_data[:data].first[:attributes]).to have_key(:price)
    expect(poster_data[:data].first[:attributes][:price]).to be_a(Float)
    expect(poster_data[:data].first[:attributes]).to have_key(:year)
    expect(poster_data[:data].first[:attributes][:year]).to be_a(Integer)
    expect(poster_data[:data].first[:attributes]).to have_key(:vintage)
    expect([true, false]).to include(poster_data[:data].first[:attributes][:vintage])   #Weird way to write this test...maybe refactor later
    expect(poster_data[:data].first[:attributes]).to have_key(:img_url)
    expect(poster_data[:data].first[:attributes][:img_url]).to be_a(String)
  end

  it 'can update a poster' do
    id = Poster.create(
    name: "TEST",
    description: "This is a test..",
    price: 10.00,
    year: 2,
    vintage: false,
    img_url:  "nil"
    ).id
    previous_name = Poster.last.name
    updated_poster_params = { name: "TEST II", description: "This is another test." }
    headers = {"CONTENT_TYPE" => "application/json"}
    # binding.pry
    patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: updated_poster_params})
    poster = Poster.find_by(id: id)
    expect(response).to be_successful
    expect(poster.name).to_not eq(previous_name)
    expect(poster.name).to eq("TEST II")
    
  end

end