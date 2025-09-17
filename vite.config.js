import { defineConfig } from "vite";

export default defineConfig({
	root: "./dist",
	server: {
		port: 3000,
		open: true,
		watch: {
			usePolling: true,
		},
	},
	build: {
		outDir: "../dist-build",
	},
});
