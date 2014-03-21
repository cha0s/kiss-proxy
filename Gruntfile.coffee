
module.exports = (grunt) ->
	
	coffees = [
		'src/**/*.coffee'
	]
	
	mapped = grunt.file.expandMapping coffees, "lib/",
		rename: (destBase, destPath) ->
			destPath = destPath.replace 'src/', ''
			destBase + destPath.replace /\.coffee$/, '.js'
	
	config =
		
		pkg: grunt.file.readJSON 'package.json'
		
		coffee: sources: files: mapped
				
		clean: sources: mapped.map (file) -> file.dest
				
	
	grunt.initConfig config

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	
	grunt.registerTask('default', ['coffee']);
