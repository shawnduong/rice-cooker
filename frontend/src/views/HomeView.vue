<!-- Script -->

<script setup lang="ts">

import Header from "../components/Header/Header.vue"
import Personal from "../components/Form/Personal.vue"
import Finish from "../components/Finish/Finish.vue"

</script>

<!-- Template -->

<template>

<Header />
<div id="main">
	<Personal /><hr>
	<Finish />
</div>

</template>

<!-- Style -->

<style scoped>

#main {
	margin: 60px 15%;
}

</style>
