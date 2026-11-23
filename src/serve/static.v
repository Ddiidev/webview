module serve

import net
import veb
import os

pub struct Context {
	veb.Context
}

pub struct App {
	veb.StaticHandler
}

pub fn (mut app App) index(mut ctx Context) veb.Result {
	index_file := app.static_files['/index.html'] or { '' }
	if index_file != '' {
		return ctx.html(os.read_file(index_file) or { panic(err) })
	}
	return ctx.text('Not found')
}

// serve_static serves a UI that has been built into a static site on localhost and
// navigates to it address. Optionally, a port can be specified to serve the site.
// By default, the next free port from `4321` is used.
pub fn serve_static(ui_path string, port u16) !u16 {
	if !os.exists(ui_path) {
		return error('failed to find ui path `${ui_path}`.')
	}
	if !os.is_dir(ui_path) {
		return error('ui path `${ui_path}` is not a directory.')
	}
	mut final_port := port
	for {
		if mut l := net.listen_tcp(.ip6, ':${final_port}') {
			l.close()!
			break
		}
		final_port++
	}
	spawn fn [ui_path, final_port] () {
		mut app := &App{}
		app.mount_static_folder_at(ui_path, '/') or {}
		veb.run[App, Context](mut app, int(final_port))
	}()
	return final_port
}