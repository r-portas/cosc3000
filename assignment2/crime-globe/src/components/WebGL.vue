<template>
  <div>
    <h1>WebGL</h1>
    <canvas class="webgl-canvas" ref="canvas">
    </canvas>
  </div>
</template>

<script>
import * as axios from 'axios';

export default {
  name: 'WebGL',
  data() {
    return {
      gl: null,
      shaderProgram: null,
      shaderUrls: {
        'shader-fs': './static/shader-fs.glsl',
        '
      },
    };
  },

  methods: {
    /**
     * Initializes the webGL canvas
     */
    initGL() {
      const canvas = this.$refs.canvas;

      this.gl = canvas.getContext('webgl') || canvas.getContent('experimental-webgl');

      // Set clear color to black
      this.gl.clearColor(0.0, 0.0, 0.0, 1.0);
      // Enable depth testing
      this.gl.enable(this.gl.DEPTH_TEST);
      // Near things obscure far things
      this.gl.depthFunc(this.gl.LEQUAL);
      // Clear the color as well as the depth buffer
      this.gl.clear(this.gl.COLOR_BUFFER_BIT | this.gl.DEPTH_BUFFER_BIT);
    },

    /**
     * Initializes the shaders
     */
    initShaders() {

    },

    /**
     * Initializes the buffers
     */
    initBuffers() {

    },

    /**
     * Renders the objects onto the screen
     */
    drawScene() {
    },

    /**
     * Loads a shader
     *
     * @param {string} name - The shader name
     * @param {string} type - The type of shader, either gl.VERTEX_SHADER or gl.FRAGMENT_SHADER
     * @returns {Promise}
     */
    loadShader(name, type) {
      axios.get(this.shaderUrls[name])
        .then((resp) => {
          const shader = this.gl.createShader(type);
          this.gl.shaderSource(shader, resp);
          this.gl.compileShader(shader);

          return shader;
        });
    },
  },

  mounted() {
    this.initGL();
    this.initShaders();
    this.initBuffers();

    this.drawScene();
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

.webgl-canvas {
  width: 90%;
  height: 300px;
}

</style>
