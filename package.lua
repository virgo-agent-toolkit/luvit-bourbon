return {
  name = "virgo-agent-toolkit/bourbon",
  version = "0.2.1",
  description = "test library",
  author = "Ryan Phillips <ryan.phillips@rackspace.com>",
  contributors = {
    "Tomaz Muraus <tomaz@tomaz.me>",
    "Vladimir Dronnikov <dronnikov@gmail.com>"
  },
  dependencies = {
    "luvit/luvit@1.9.4",
    "rphillips/async@0.0.2",
  },
  files = {
    "**.lua",
    "!lit*",
    "!test*"
  }
}
