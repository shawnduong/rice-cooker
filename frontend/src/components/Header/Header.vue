<!-- Script -->

<script setup lang="ts">
</script>

<!-- Template -->

<template>

<div id="header">

	<img id="header-logo" src="@/assets/png/logo.png" />
	<h1>Rice Cooker</h1>

	<p><i>Quickly and effortlessly generate complete custom Arch Linux installation scripts.</i></p>
	<p>Check the project out on <a id="header-link" href="https://github.com/shawnduong/rice-cooker" target="_blank">GitHub</a>!</p>

	<button class="big-button" id="import-config">Import Saved Configuration</button>

</div>

</template>

<!-- Style -->

<style scoped>

#header {
	margin: 0;
	padding: 50px;
	overflow: auto;
	color: var(--background);
	background-color: var(--red);
}

#header h1 {
	font-family: "Balsamiq Sans", sans-serif;
	font-weight: 500;
	font-size: 40px;
	color: white;
}

#header-link {
	font-weight: bolder;
	text-decoration: none;
	color: #F5F5DC;
	transition-duration: 0.3s;
}

#header-link:after {
	margin: 0px 2px 0px 3px;
	background-image: url(@/assets/svg/github-logo.svg);
	background-size: 18px 18px;
	display: inline-block;
	width: 18px;
	height: 18px;
	content: "";
}

#header-logo {
	float: left;
	width: 300px;
	margin-left: 15%;
	padding: 30px;
}

</style>
