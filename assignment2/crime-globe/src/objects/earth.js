/**
 * Stores a representation of the earth
 */

export default class Earth {
  /**
   * Constructs a new earth object
   *
   * @param {int}    latBands    - The number of latitude bands
   * @param {int}    longBands   - The number of longitude bands
   * @param {int}    radius      - The radius of the earth
   */
  constructor(latBands, longBands, radius) {
    this.latBands = latBands;
    this.longBands = longBands;
    this.radius = radius;

    this.vertexPositionBuffer = [];
    this.vertexNormalBuffer = [];
    this.vertexTextureCoordBuffer = [];
    this.vertexIndexBuffer = [];

    this.rotationMatrix = mat4.create();
    mat4.identity(this.rotationMatrix);

    this.mapTexture = null;
    this.specularMap = null;

    this.vertexPositionData = [];
    this.normalData = [];
    this.textureCoordData = [];
  }

  /**
   * Initialize the buffer to store the earth
   *
   * @param {WebGL} gl - The web gl instance
   */
  initBuffers(gl) {
    this.vertexPositionData = [];
    this.normalData = [];
    this.textureCoordData = [];

    for (let latNumber = 0; latNumber <= this.latBands; latNumber += 1) {
      const theta = (latNumber * Math.PI) / this.latBands;
      const sinTheta = Math.sin(theta);
      const cosTheta = Math.cos(theta);
      for (let longNumber = 0; longNumber <= this.longBands; longNumber += 1) {
        const phi = (longNumber * 2 * Math.PI) / this.longBands;
        const sinPhi = Math.sin(phi);
        const cosPhi = Math.cos(phi);
        const x = cosPhi * sinTheta;
        const y = cosTheta;
        const z = sinPhi * sinTheta;
        const u = 1 - (longNumber / this.longBands);
        const v = 1 - (latNumber / this.latBands);

        this.normalData.push(x);
        this.normalData.push(y);
        this.normalData.push(z);

        this.textureCoordData.push(u);
        this.textureCoordData.push(v);
        this.vertexPositionData.push(this.radius * x);
        this.vertexPositionData.push(this.radius * y);
        this.vertexPositionData.push(this.radius * z);
      }
    }

    const indexData = [];
    for (let latNumber = 0; latNumber < this.latBands; latNumber += 1) {
      for (let longNumber = 0; longNumber < this.longBands; longNumber += 1) {
        const first = (latNumber * (this.longBands + 1)) + longNumber;
        const second = first + this.longBands + 1;
        indexData.push(first);
        indexData.push(second);
        indexData.push(first + 1);
        indexData.push(second);
        indexData.push(second + 1);
        indexData.push(first + 1);
      }
    }

    this.vertexNormalBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexNormalBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(this.normalData), gl.STATIC_DRAW);
    this.vertexNormalBuffer.itemSize = 3;
    this.vertexNormalBuffer.numItems = this.normalData.length / 3;

    this.vertexTextureCoordBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexTextureCoordBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(this.textureCoordData), gl.STATIC_DRAW);
    this.vertexTextureCoordBuffer.itemSize = 2;
    this.vertexTextureCoordBuffer.numItems = this.textureCoordData.length / 2;

    this.vertexPositionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexPositionBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(this.vertexPositionData), gl.STATIC_DRAW);
    this.vertexPositionBuffer.itemSize = 3;
    this.vertexPositionBuffer.numItems = this.vertexPositionData.length / 3;

    this.vertexIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.vertexIndexBuffer);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(indexData), gl.STATIC_DRAW);
    this.vertexIndexBuffer.itemSize = 1;
    this.vertexIndexBuffer.numItems = indexData.length;
  }

  static handleLoadedTexture(texture, gl) {
    gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA,
      gl.RGBA, gl.UNSIGNED_BYTE, texture.image);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER,
      gl.LINEAR_MIPMAP_NEAREST);
    gl.generateMipmap(gl.TEXTURE_2D);
    gl.bindTexture(gl.TEXTURE_2D, null);
  }

  /**
   * Initializes the texture
   *
   * @param {WebGL} gl - The web gl instance
   */
  initTextures(gl) {
    this.mapTexture = gl.createTexture();
    this.mapTexture.image = new Image();
    this.mapTexture.image.onload = () => {
      this.handleLoadedTexture(this.mapTexture);
    };

    this.mapTexture.image.src = './static/earth.jpg';
    this.specularMap = gl.createTexture();
    this.specularMap.image = new Image();
    this.specularMap.image.onload = () => {
      this.handleLoadedTexture(this.specularMap);
    };

    this.specularMap.image.src = './static/earth-specular.gif';
  }

  /**
   * Draws the earth
   *
   * @param {WebGL}  gl            - The web gl instance
   * @param {Shader} shaderProgram - The shader program
   * @param {mat4}   pMatrix       - The projection matrix
   * @param {mat4}   mvMatrix      - The model view matrix
   */
  draw(gl, shaderProgram, pMatrix, mvMatrix) {
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, this.mapTexture);
    gl.uniform1i(shaderProgram.samplerUniform, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexPositionBuffer);
    gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute,
      this.vertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexTextureCoordBuffer);
    gl.vertexAttribPointer(shaderProgram.textureCoordAttribute,
      this.vertexTextureCoordBuffer.itemSize, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexNormalBuffer);
    gl.vertexAttribPointer(shaderProgram.vertexNormalAttribute,
      this.vertexNormalBuffer.itemSize, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.vertexIndexBuffer);

    // Set the matrix uniforms
    gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix);
    gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix);

    const normalMatrix = mat3.create();
    mat4.toInverseMat3(mvMatrix, normalMatrix);
    mat3.transpose(normalMatrix);
    gl.uniformMatrix3fv(shaderProgram.nMatrixUniform, false, normalMatrix);


    gl.drawElements(gl.TRIANGLES, this.vertexIndexBuffer.numItems, gl.UNSIGNED_SHORT, 0);
  }

  /**
   * Returns the rotation matrix
   *
   * @return {mat4} The rotation matrix
   */
  getRotationMatrix() {
    return this.rotationMatrix;
  }

}
