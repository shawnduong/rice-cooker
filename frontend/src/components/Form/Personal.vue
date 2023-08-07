<!-- Script -->

<script setup lang="ts">

import { ref } from "vue"

const s_home_style = ref()

</script>

<!-- Template -->

<template>

	<div id="personal">

		<h2>Personal</h2>

		<label for="s_username" class="big-label">
			<span>Username </span><a>(?)</a>
		</label>
		<input type="text" id="s_username" />

		<label for="s_hostname" class="big-label">
			<span>Hostname </span><a>(?)</a>
		</label>
		<input type="text" id="s_hostname" />

		<label class="big-label">
			<span>Home Style </span><a>(?)</a>
		</label>
		<div class="radio-item">
			<input type="radio" v-model="s_home_style" id="s_home_style_full" value="full" />
			<label for="s_home_style_full">Full</label>
		</div>
		<div class="radio-item">
			<input type="radio" v-model="s_home_style" id="s_home_style_minimal" value="minimal" />
			<label for="s_home_style_minimal">Minimal</label>
		</div>
		<div class="radio-item">
			<input type="radio" v-model="s_home_style" id="s_home_style_none" value="none" />
			<label for="s_home_style_none">None</label>
		</div>

	</div>

</template>

<!-- Style -->

<style scoped>

</style>
