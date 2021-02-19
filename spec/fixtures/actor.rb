#
# === Source ===
# Repo: github.com/jsonapi-serializer
# File: spec/fixtures/actor.rb
#

require_relative './user'

class Actor < User
  attr_accessor :movies, :movie_ids

  def self.fake(id = nil)
    faked = super(id)
    faked.movies = []
    faked.movie_ids = []
    faked
  end

  def movie_urls
    {
      movie_url: movies[0]&.url
    }
  end
end

class ActorSerializer < UserSerializer
  set_type :actor

  attribute :email, if: ->(_object, params) { params[:conditionals_off].nil? }

  has_many(
    :played_movies,
    serializer: :movie,
    links: :movie_urls,
    if: ->(_object, params) { params[:conditionals_off].nil? }
  ) do |object|
    object.movies
  end
end

