window.LoLA =
  Config: {
    cdn: 'http://ddragon.leagueoflegends.com/cdn'
    version: '5.16.1'
    championImageURL : (image) -> this.cdn + '/' + this.version + '/img/champion/' + image
    itemImageURL     : (image) -> this.cdn + '/' + this.version + '/img/item/' + image
    spriteImageURL   : (image) -> this.cdn + '/' + this.version + '/img/sprite/' + image
  },
  Views: {},
  Components: {}
