const chai                             = require("chai");
const chaiHttp                         = require("chai-http");
const mongoose                         = require("mongoose");
const { areaCalculator }               = require("../controllers/areaCalculator");
const should                           = chai.should();
const app                              = require("../app");

chai.use(chaiHttp);

describe("GET /", function () {
  it("should succes connect database", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .get("/")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.should.be.a("object");
        res.text.should.equal("Measurement App Server");
        done();
      });
  });
});

describe("GET /shape", function () {
  it("should have status 200", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .get("/shape")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.should.be.a("array");
        done();
      });
  });

  it("should have list of shapes", function (done) {
    chai
      .request(app)
      .get("/shape")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.body.should.be.a("array");
        res.body[0].name.should.be.a("string");
        res.body[0].perimeter.should.be.a("number");
        res.body[0].area.should.be.a("number");
        res.body[0].coordinates.should.be.a("array");
        res.body[0].lengths.should.be.a("array");
        done();
      });
  });
});

describe("GET /shape", function () {
  it("should have status 400", function (done) {
    setTimeout(done, 1000);
    chai
      .request(app)
      .get('/shapes')
      .catch(err => err.response)
      .then(res => {
        res.should.have.status(400);
      })
  });
});

describe("POST /shape/add", function () {
  let mockPayload = { 
    name: "test", 
    perimeter: 100, 
    area: 100, 
    coordinates: [[100]], 
    lengths: [[10]]
  };
  let mockErrorPayload = { 
    name: "test", 
    perimeter: 100 
  };
  let shapeId;
  it("should not add new item", function (done) {
    chai
      .request(app)
      .post("/shape/add")
      .send(mockErrorPayload)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(400);
        res.body.should.be.a("object");
        res.body.errors.should.be.a("object");
        done();
      });
  });

  it("should return new item", function (done) {
    chai
      .request(app)
      .post("/shape/add")
      .send(mockPayload)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        shapeId = res.body._id;
        res.should.have.status(200);
        res.body.should.be.a("object");
        res.body.name.should.equal("test");
        res.body.perimeter.should.equal(100);
        res.body.area.should.equal(100);
        res.body.coordinates.should.be.a("array");
        res.body.lengths.should.be.a("array");
        done();
      });
  });

  describe("PUT /shape/update/:shapeId", function () {
    it("should not have return updated shape", function (done) {
      let mockErrorUpdatePayload = {
        name: "updated test",
        perimeter: "string",
        area: 200,
        coordinates: [
          []
        ],
        lengths: [
          []
        ]
      };
      chai
        .request(app)
        .put(`/shape/update/${shapeId}`)
        .send(mockErrorUpdatePayload)
        .end(function (err, res) {
          if (err) {
            console.log(err);
            done();
          }
          res.should.have.status(400);
          res.body.should.be.a("object");
          done();
        });
    });

    it("should have return updated shape", function (done) {
      let mockUpdatePayload = {
        name: "updated test",
        perimeter: 200,
        area: 200,
        perimeter: 200,
        coordinates: [
          [200]
        ],
        lengths: [
          [200]
        ]
      };
      this.timeout(5000);
      chai
        .request(app)
        .put(`/shape/update/${shapeId}`)
        .send(mockUpdatePayload)
        .end(function (err, res) {
          if (err) {
            console.log(err);
            done();
          }
          res.should.have.status(200);
          res.body.name.should.equal("updated test");
          res.body.perimeter.should.equal(200);
          res.body.area.should.equal(200);
          res.body.coordinates.should.be.a("array");
          res.body.lengths.should.be.a("array");
          done();
        });
    });
  });

  describe("DELETE /shape/delete/:shapeId", function () {
    it("should not have return deleted shape", function (done) {
      chai
        .request(app)
        .delete(`/shape/delete/123`)
        .end(function (err, res) {
          if (err) {
            console.log(err);
            done();
          }
          res.should.have.status(400);
          res.body.should.be.a("object");
          done();
        });
    });

    it("should have return deleted shape", function (done) {
      this.timeout(5000);
      chai
        .request(app)
        .delete(`/shape/delete/${shapeId}`)
        .end(function (err, res) {
          if (err) {
            console.log(err);
            done();
          }
          res.should.have.status(200);
          res.body.name.should.equal("updated test");
          res.body.perimeter.should.equal(200);
          res.body.area.should.equal(200);
          res.body.coordinates.should.be.a("array");
          res.body.lengths.should.be.a("array");
          done();
        });
    });
  });
});

describe("area calculator", function () {
  it(`area of
   _____      _____
  |     |    |     |
  |     |____|     |
  |                |
  |________________|
  
  should be 20

  `, function (done) {
      let arrayOfCoordinates = [
        [1, 6],
        [3, 6],
        [3, 4],
        [5, 4],
        [5, 6],
        [7, 6],
        [7, 2],
        [1, 2]
      ];
      let area = areaCalculator(arrayOfCoordinates);
      area.should.be.a("number");
      area.should.be.equal(20);
      done();
    });
});

describe("GET /user", function () {
  it("should have status 200", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .get("/user")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.should.be.a("array");
        done();
      });
  });

  it("should have list of user", function (done) {
    chai
      .request(app)
      .get("/user")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.body.should.be.a("array");
        res.body[0].username.should.be.a("string");
        done();
      });
  });
});

describe("GET /user", function () {
  it("should have status 400", function (done) {
    setTimeout(done, 1000);
    chai
      .request(app)
      .get('/users')
      .catch(err => err.response)
      .then(res => {
        res.should.have.status(400);
      })
  });
});

let userId;
describe("POST /user/add", function () {
  let userPayload = {
    username: "test"
  };
  let userErrorPayload = {
    name: "test"
  };

  it("should not add new user", function (done) {
    chai
      .request(app)
      .post("/user/add")
      .send(userErrorPayload)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(400);
        res.body.should.be.a("object");
        res.body.errors.should.be.a("object");
        done();
      });
  });
  it("should return new user", function (done) {
    chai
      .request(app)
      .post("/user/add")
      .send(userPayload)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        userId = res.body._id;
        res.should.have.status(200);
        res.body.should.be.a("object");
        res.body.username.should.equal("test");
        done();
      });
  });
});

describe("DELETE /user/delete/:userId", function () {
  it("should not have return deleted user", function (done) {
    chai
      .request(app)
      .delete(`/user/delete/123`)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(400);
        res.body.should.be.a("object");
        done();
      });
  });

  it("should have return deleted user", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .delete(`/user/delete/${userId}`)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.username.should.equal("test");
        done();
      });
  });
});

describe("GET /floor", function () {
  it("should have status 200", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .get("/floor")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.should.be.a("array");
        done();
      });
  });

  it("should have list of floor", function (done) {
    chai
      .request(app)
      .get("/floor")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.body.should.be.a("array");
        res.body[0].type.should.be.a("string");
        res.body[0].area.should.be.a("number");
        res.body[0].price.should.be.a("number");
        done();
      });
  });
});

describe("GET /floor", function () {
  it("should have status 400", function (done) {
    setTimeout(done, 1000);
    chai
      .request(app)
      .get('/floors')
      .catch(err => err.response)
      .then(res => {
        res.should.have.status(400);
      })
  });
});

let floorId;
describe("POST /floor/add", function () {
  let floorPayload ={
    type: "anatolia",
    price: 100, 
    area: 100
  };
  let floorErrorPayload = {
    type: "anatolia",
    price: 100
  };

  it("should not add new floor", function (done) {
    chai
      .request(app)
      .post("/floor/add")
      .send(floorErrorPayload)
      .end(function (err, res) {
        res.should.have.status(400);
        res.body.should.be.a("object");
        res.body.errors.should.be.a("object");
        done();
      });
  });

  it("should return new floor", function (done) {
    chai
      .request(app)
      .post("/floor/add")
      .send(floorPayload)
      .end(function (err, res) {
        floorId = res.body._id;
        res.should.have.status(200);
        res.body.should.be.a("object");
        res.body.type.should.equal("anatolia");
        res.body.price.should.equal(100);
        res.body.area.should.equal(100);
        done();
      });
  });
});

describe("DELETE /floor/delete/:floorId", function () {
  it("should not have return deleted floor", function (done) {
    chai
      .request(app)
      .delete(`/floor/delete/123`)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(400);
        res.body.should.be.a("object");
        done();
      });
  });

  it("should have return deleted floor", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .delete(`/floor/delete/${floorId}`)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.type.should.equal("anatolia");
        res.body.price.should.equal(100);
        res.body.area.should.equal(100);
        done();
      });
  });
});

describe("GET /wall", function () {
  it("should have status 200", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .get("/wall")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.should.be.a("array");
        done();
      });
  });

  it("should have list of wall", function (done) {
    chai
      .request(app)
      .get("/wall")
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.body.should.be.a("array");
        res.body[0].type.should.be.a("string");
        res.body[0].area.should.be.a("number");
        res.body[0].price.should.be.a("number");
        done();
      });
  });
});

describe("GET /wall", function () {
  it("should have status 400", function (done) {
    setTimeout(done, 1000);
    chai
      .request(app)
      .get('/walls')
      .catch(err => err.response)
      .then(res => {
        res.should.have.status(400);
      })
  });
});

let wallId;
describe("POST /wall/add", function () {
  let wallPayload ={
    type: "paint",
    price: 100, 
    area: 100
  };
  let wallErrorPayload = {
    type: "paint",
    price: 100
  };

  it("should not add new wall", function (done) {
    chai
      .request(app)
      .post("/wall/add")
      .send(wallErrorPayload)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(400);
        res.body.should.be.a("object");
        res.body.errors.should.be.a("object");
        done();
      });
  });

  it("should return new wall", function (done) {
    chai
      .request(app)
      .post("/wall/add")
      .send(wallPayload)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        wallId = res.body._id;
        res.should.have.status(200);
        res.body.should.be.a("object");
        res.body.type.should.equal("paint");
        res.body.price.should.equal(100);
        res.body.area.should.equal(100);
        done();
      });
  });
});

describe("DELETE /wall/delete/:wallId", function () {
  it("should not have return deleted wall", function (done) {
    chai
      .request(app)
      .delete(`/wall/delete/123`)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(400);
        res.body.should.be.a("object");
        done();
      });
  });

  it("should have return deleted wall", function (done) {
    this.timeout(5000);
    chai
      .request(app)
      .delete(`/wall/delete/${wallId}`)
      .end(function (err, res) {
        if (err) {
          console.log(err);
          done();
        }
        res.should.have.status(200);
        res.body.type.should.equal("paint");
        res.body.price.should.equal(100);
        res.body.area.should.equal(100);
        mongoose.connection.close(function () {
          console.log("Mongoose connection disconnected");
        });
        done();
      });
  });
});