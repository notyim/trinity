package gaia

import (
	"os"
	"strconv"

	"github.com/notyim/gaia/sidekiq"
)

type Config struct {
	AppEnv string

	MongoURI    string
	MongoDBName string

	*RedisConfig
}

type RedisConfig struct {
	Addr string
	DB   int
}

func LoadConfig() *Config {
	c := Config{
		AppEnv:      "development",
		MongoDBName: "trinity_development",
	}

	c.MongoURI = os.Getenv("MONGO_URI")
	if c.MongoURI == "" {
		c.MongoURI = "mongodb://localhost:27017"
	}

	if os.Getenv("MONGO_DBNAME") != "" {
		c.MongoDBName = os.Getenv("MONGO_DBNAME")
	}

	redisConfig := &RedisConfig{Addr: "localhost:6379", DB: 0}
	if os.Getenv("REDIS_ADDR") != "" {
		redisConfig.Addr = os.Getenv("REDIS_ADDR")
	}

	if os.Getenv("REDIS_DB") != "" {
		redisConfig.DB, _ = strconv.Atoi(os.Getenv("REDIS_DB"))
	}
	c.RedisConfig = redisConfig

	return &c
}

func (c *Config) Redis() *sidekiq.Config {
	return &sidekiq.Config{
		Addr: c.RedisConfig.Addr,
		DB:   c.RedisConfig.DB,
	}
}
