function password_show() {
	id = document.querySelector('input#password');
	show = document.querySelector('i#password_show');
	if (id.getAttribute('type') == 'password') {
		id.setAttribute('type','text');
		show.innerHTML = 'visibility';
	}else{
		id.setAttribute('type','password');
		show.innerHTML = 'visibility_off';
	}
}
function auth() {
	if (!$('#login').value || !$('#password').value)
		return false;
	gad.load('../cgi-bin/login.sh?login='+$('#login').value+'&password='+$('#password').value,'get',
		function(res) {
			if (!res) {
				$('#card').innerHTML = '<div style="color:#F44336;">Ошибка входа</div>';
				return false;
			}
			gad.setSession('login',$('#login').value);
			gad.setSession('password',$('#login').password);
			location.href = 'index.html';
		}
	);
}
function main() {}
