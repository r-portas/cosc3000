<template>
  <div id="app">
    <WebGL></WebGL>
  </div>
</template>

<script>
import WebGL from './components/WebGL';

export default {
  name: 'app',
  components: {
    WebGL,
  },
};
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
