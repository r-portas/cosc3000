<template>
  <div>
    <h1>WebGL</h1>
    <canvas class='webgl-canvas' ref='canvas'>
    </canvas>
  </div>
</template>

<script>
import Earth from '../objects/earth';
import shaderFs from '../shaders/fragment-lighting-fs';
import shaderVs from '../shaders/fragment-lighting-vs';


export default {
  name: 'WebGL',
  data() {
    return {
      gl: null,
      shaderProgram: null,

      earth: null,

      // Projection matrix
      pMatrix: null,

      // Model view matrix
      mvMatrix: null,

      // Normal matrix
      normalMatrix: null,
    };
  },

  methods: {
    /**
     * Initializes the webGL canvas
     */
    initGL() {
      const canvas = this.$refs.canvas;

      this.gl = canvas.getContext('webgl') || canvas.getContent('experimental-webgl');

      this.gl.viewportWidth = canvas.width;
      this.gl.viewportHeight = canvas.height;

      // Set clear color to black
      this.gl.clearColor(0.0, 0.0, 0.0, 1.0);

      // Enable depth testing
      this.gl.enable(this.gl.DEPTH_TEST);

      // Near things obscure far things
      // this.gl.depthFunc(this.gl.LEQUAL);

      this.pMatrix = mat4.create();
      this.mvMatrix = mat4.create();
    },

    /**
     * Initializes the shaders
     */
    initShaders() {
      this.shaderProgram = this.gl.createProgram();

      const shaderFsObj = this.gl.createShader(this.gl.FRAGMENT_SHADER);
      this.gl.shaderSource(shaderFsObj, shaderFs);
      this.gl.compileShader(shaderFsObj);

      const shaderVsObj = this.gl.createShader(this.gl.VERTEX_SHADER);
      this.gl.shaderSource(shaderVsObj, shaderVs);
      this.gl.compileShader(shaderVsObj);

      this.gl.attachShader(this.shaderProgram, shaderVsObj);
      this.gl.attachShader(this.shaderProgram, shaderFsObj);
      this.gl.linkProgram(this.shaderProgram);

      this.gl.useProgram(this.shaderProgram);

      this.shaderProgram.vertexPositionAttribute = this.gl.getAttribLocation(this.shaderProgram, 'aVertexPosition');
      this.gl.enableVertexAttribArray(this.shaderProgram.vertexPositionAttribute);

      this.shaderProgram.vertexNormalAttribute = this.gl.getAttribLocation(this.shaderProgram, 'aVertexNormal');
      this.gl.enableVertexAttribArray(this.shaderProgram.vertexNormalAttribute);

      this.shaderProgram.textureCoordAttribute = this.gl.getAttribLocation(this.shaderProgram, 'aTextureCoord');
      this.gl.enableVertexAttribArray(this.shaderProgram.textureCoordAttribute);

      this.shaderProgram.pMatrixUniform = this.gl.getUniformLocation(this.shaderProgram, 'uPMatrix');
      this.shaderProgram.mvMatrixUniform = this.gl.getUniformLocation(this.shaderProgram, 'uMVMatrix');
      this.shaderProgram.nMatrixUniform = this.gl.getUniformLocation(this.shaderProgram, 'uNMatrix');
      this.shaderProgram.colorMapSamplerUniform = this.gl.getUniformLocation(this.shaderProgram, 'uColorMapSampler');
      this.shaderProgram.specularMapSamplerUniform = this.gl.getUniformLocation(this.shaderProgram, 'uSpecularMapSampler');
      this.shaderProgram.useColorMapUniform = this.gl.getUniformLocation(this.shaderProgram, 'uUseColorMap');
      this.shaderProgram.useSpecularMapUniform = this.gl.getUniformLocation(this.shaderProgram, 'uUseSpecularMap');
      this.shaderProgram.useLightingUniform = this.gl.getUniformLocation(this.shaderProgram, 'uUseLighting');
      this.shaderProgram.ambientColorUniform = this.gl.getUniformLocation(this.shaderProgram, 'uAmbientColor');
      this.shaderProgram.pointLightingLocationUniform = this.gl.getUniformLocation(this.shaderProgram, 'uPointLightingLocation');
      this.shaderProgram.pointLightingSpecularColorUniform = this.gl.getUniformLocation(this.shaderProgram, 'uPointLightingSpecularColor');
      this.shaderProgram.pointLightingDiffuseColorUniform = this.gl.getUniformLocation(this.shaderProgram, 'uPointLightingDiffuseColor');
    },

    /**
     * Initializes the buffers
     */
    initBuffers() {
      this.earth.initBuffers(this.gl);
    },

    initTextures() {
      this.earth.initTextures(this.gl);
    },

    /**
     * Draws the scene
     */
    drawScene() {
      this.gl.viewport(0, 0, this.gl.viewportWidth, this.gl.viewportHeight);

      // Clear the color as well as the depth buffer
      this.gl.clear(this.gl.COLOR_BUFFER_BIT | this.gl.DEPTH_BUFFER_BIT);

      // Set the perspective
      mat4.perspective(45, this.gl.viewportWidth / this.gl.viewportHeight,
        0.1, 100.0, this.pMatrix, this.perVertexProgram);

      mat4.identity(this.mvMatrix);
      mat4.translate(this.mvMatrix, [0, 0, -6]);
      mat4.multiply(this.mvMatrix, this.earth.getRotationMatrix());

      this.earth.draw(this.gl, this.shaderProgram, this.pMatrix, this.mvMatrix);
    },

    degToRadian(degrees) {
      return (degrees * Math.PI) / 180;
    },

    /**
     * Creates the program
     */
    createProgram(fragShaderData, vertShaderData) {
      const program = this.gl.createProgram();

      const vertShader = this.loadShader(vertShaderData, this.gl.VERTEX_SHADER);
      const fragShader = this.loadShader(fragShaderData, this.gl.FRAGMENT_SHADER);
      this.gl.attachShader(program, fragShader);
      this.gl.attachShader(program, vertShader);

      // Run the rest of the program create script
      this.gl.linkProgram(program);

      program.vertexPositionAttribute = this.gl.getAttribLocation(program, 'aVertexPosition');
      this.gl.enableVertexAttribArray(program.vertexPositionAttribute);

      program.vertexNormalAttribute = this.gl.getAttribLocation(program, 'aVertexNormal');
      this.gl.enableVertexAttribArray(program.vertexNormalAttribute);

      program.textureCoordAttribute = this.gl.getAttribLocation(program, 'aTextureCoord');
      this.gl.enableVertexAttribArray(program.textureCoordAttribute);

      program.pMatrixUniform = this.gl.getUniformLocation(program, 'uPMatrix');
      program.mvMatrixUniform = this.gl.getUniformLocation(program, 'uMVMatrix');
      program.nMatrixUniform = this.gl.getUniformLocation(program, 'uNMatrix');
      program.mapSamplerUniform = gl.getUniformLocation(program, 'uColorMapSampler');
      program.specularMapSamplerUniform = gl.getUniformLocation(program, 'uSpecularMapSampler');
      program.useTexturesUniform = this.gl.getUniformLocation(program, 'uUseTextures');
      program.useLightingUniform = this.gl.getUniformLocation(program, 'uUseLighting');
      program.ambientColorUniform = this.gl.getUniformLocation(program, 'uAmbientColor');
      program.pointLightingLocationUniform = this.gl.getUniformLocation(program, 'uPointLightingLocation');
      program.pointLightingColorUniform = this.gl.getUniformLocation(program, 'uPointLightingColor');
      program.lightingDirectionUniform = this.gl.getUniformLocation(program, 'uLightingDirection');
      program.directionalColorUniform = this.gl.getUniformLocation(program, 'uDirectionalColor');

      return program;
    },

    tick() {
      requestAnimFrame(this.tick);

      this.drawScene();
    },
  },


  mounted() {
    // Create the earth
    this.earth = new Earth(20, 20, 2);

    this.initGL();
    this.initShaders();
    this.initTextures();
    this.initBuffers();

    this.tick();
  },
};
</script>

<!-- Add 'scoped' attribute to limit CSS to this component only -->
<style scoped>

.webgl-canvas {
  width: 90%;
  height: 300px;
}

</style>
