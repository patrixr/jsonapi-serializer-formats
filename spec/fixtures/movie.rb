#
# === Source ===
# Repo: github.com/jsonapi-serializer
# File: spec/fixtures/actor.rb
#

class Movie
  attr_accessor(
    :id,
    :name,
    :year,
    :rating,
    :rating_count,
    :view_count,
    :actor_or_user,
    :actors,
    :actor_ids,
    :polymorphics,
    :owner,
    :owner_id
  )

  def self.fake(id = nil)
    faked = new
    faked.id = id || FFaker::Guid.guid
    faked.name = FFaker::Movie.title
    faked.year = FFaker::Vehicle.year
    faked.rating = FFaker::Random.rand(5)
    faked.rating_count = FFaker::Random.rand(100000)
    faked.view_count = FFaker::Random.rand(100000)
    faked.actors = [Actor.fake]
    faked.actor_ids = faked.actors.map(&:uid)
    faked.polymorphics = []
    faked.owner = User.fake
    faked.owner_id = faked.owner.uid
    faked
  end

  def url(obj = nil)
    @url ||= FFaker::Internet.http_url
    return @url if obj.nil?

    @url + '?' + obj.hash.to_s
  end

  def owner=(ownr)
    @owner = ownr
    @owner_id = ownr.uid
  end

  def actors=(acts)
    @actors = acts
    @actor_ids = actors.map do |actor|
      actor.movies << self
      actor.uid
    end
  end
end

class MovieSerializer
  include JSONAPI::Serializer

  set_type :movie

  attributes :name
  attribute :release_year do |object|
    object.year
  end

  link :self, :url

  belongs_to :owner, serializer: UserSerializer

  belongs_to :actor_or_user,
             id_method_name: :uid,
             polymorphic: {
               Actor => :actor,
               User => :user
             }

  has_many(
    :actors,
    meta: proc { |record, _| { count: record.actors.length } },
    links: {
      actors_self: :url,
      related: ->(obj) { obj.url(obj) }
    }
  )
  has_one(
    :creator,
    object_method_name: :owner,
    id_method_name: :uid,
    serializer: ->(object, _params) { UserSerializer if object.is_a?(User) }
  )
  has_many(
    :actors_and_users,
    id_method_name: :uid,
    polymorphic: {
      Actor => :actor,
      User => :user
    }
  ) do |obj|
    obj.polymorphics
  end

  has_many(
    :dynamic_actors_and_users,
    id_method_name: :uid,
    polymorphic: true
  ) do |obj|
    obj.polymorphics
  end

  has_many(
    :auto_detected_actors_and_users,
    id_method_name: :uid
  ) do |obj|
    obj.polymorphics
  end
end
