<master>
    <div class="container-fluid py-3 semi-trans">
        <div class="row">
            <div class="col-lg-6 col-md-8 col-sm-8 col-xs-8 mx-auto" style="margin-top: 10%;">
                <div class="card card-body">
                    <div class="text-center mb-4 alert alert-primary" role="alert">
                        <h4>Sign In</h4>
                    </div>
                    <fieldset>
                        <div class="form-group">
                            <label for="userName">&nbsp;User Name.</label>
                            <input class="form-control input-lg" 
                                placeholder="Use E-mail Address as User Name." 
                                id="userName" 
                                name="userName" 
                                type="email">
                        </div>
                        <div class="form-group">
                            <label for="passWord">&nbsp;Password.</label>
                            <input class="form-control input-lg" 
                                placeholder="Password." 
                                id="passWord" 
                                name="passWord" 
                                value="" 
                                type="password">
                        </div>
                        <button class="btn btn-lg btn-primary btn-block" 
                                type="submit" 
                                onclick={onsubmituser}>
                            <i class="fas fa-key"></i>
                            Sign In
                        </button>
                    </fieldset>
                    <div class="text-center m-0 p-0 mb-1">
                        <label class="m-0 p-1 d-inline-block">User :</label>
                        <label class="m-0 p-1 d-inline-block curr-user" id="currUser"></label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <br/>

    <!-- Modal -->
    <div class="modal fade" id="selectCustomer" tabindex="3" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Please Choose Company.</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="container-fluid">
                        <div class="list-group m-0 p-0">
                            <a each={company in companies} href="javascript:void(0);"
                                class="list-group-item list-group-item-action m-auto p-0"
                                customerId="{company.customerId}"
                                onclick={onsubmitusercompany}>
                                <div class="d-flex m-0 p-1">
                                    <div class="flex-column m-1 p-0">
                                        <div class="profile-image align-middle"></div>
                                    </div>
                                    <div class="flex-column m-0 p-1">
                                        <div class="row m-0 p-0">
                                            <p>{company.CustomerName}</p>
                                        </div>
                                        <!--
                                        <div class="row m-0 p-0">
                                            <p>{company.FullNameNative}</p>
                                        </div>
                                        -->
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" 
                            class="btn btn-secondary" 
                            data-dismiss="modal">
                            Close
                    </button>
                </div>
            </div>
        </div>
    </div>
    <style>
        :scope {
            width: 100%;
            height: 100%;
        }
        .semi-trans { opacity: 0.97; }
        .err-msg { color: red; }
        .curr-user { color: navy; }
        .profile-image { 
            margin: 0px auto;
            padding: 1px;
            width: 30px;
            height: 30px;
            background-color: rebeccapurple;
            border: 1px solid cornflowerblue;
            border-radius: 50%;
        }
    </style>
    <script>
        this.showToolTip = ($ctrl, msg, placement) => {
            if (!$ctrl) return;
            
            let options = { 
                trigger: 'manual',
                placement: (placement) ? placement : 'top',
                title: msg
            };

            let attr = $ctrl.attr('rel');
            if (!attr) {
                $ctrl.attr('rel', 'tooltip');
            }

            $ctrl.tooltip(options).tooltip('show');
            setTimeout(() => { 
                //$ctrl.tooltip('hide');
                $ctrl.tooltip('dispose');
            }, 3000);
        };

        this.showAlert = (msg) => {
            let x = "alert-primary";
            let $ctrl = $('[role="alert"]');

            $ctrl.removeClass("alert-primary");
            $ctrl.addClass("alert-danger");
            
            this.showToolTip($ctrl, msg, 'bottom');
            
            setTimeout(() => { 
                $ctrl.removeClass("alert-danger");
                $ctrl.addClass("alert-primary");
            }, 3000);
        };
        /*
        this.showErrMessage = (msg) => {
            let str = (msg) ? msg : '';
            //console.log(str);
            $('#errMsg').text(str);
        };
        */
        this.updateCurrentUser = (user) => {
            let str = (user) ? user.FullNameNative + ' (' + user.CustomerName + ')' : '';
            //console.log(str);
            $('#currUser').text(str);
        };

        this.validateUser = (user) => {
            if (!user) {
                this.showErrMessage('User is null.');
                return false;
            }
            if (!user.userName || user.userName.trim() === '') {
                //this.showErrMessage('Please Enter User Name.');
                this.showToolTip($('#userName'), 'Please Enter User Name.');
                return false;
            }
            if (!user.passWord || user.passWord.trim() === '') {
                //this.showErrMessage('Please Enter Password.');
                this.showToolTip($('#passWord'), 'Please Enter Password.');
                return false;
            }
            return true;
        };

        this.companies = [];

        this.doSignIn = (user, selectUsersCallback) => {
            if (!user) {
                return;
            }
            // test@test.co.th
            // admin@super-power.co.th
            // chumpon@softbase.co.th
            let fn = app.userService.signin(user);
            $.when(fn).then((r) => {
                if (r && r.length > 0) {
                    if (r.length === 1) {
                        this.updateCurrentUser(r[0]);
                    }
                    else {
                        //console.log('Has more than one users. Please select company.');
                        //console.log(r);
                        if (!selectUsersCallback) {
                            this.showAlert('Has more than one users. Please select company.');
                            return;
                        }
                        selectUsersCallback(r);
                    }
                }
                else {
                    //this.showErrMessage('No user found.');
                    this.showAlert('No user found.');
                }
            });
        };

        this.onsubmituser = (e) => {
            e.preventDefault();
            let user = {
                userName: $('#userName').val(),
                passWord: $('#passWord').val()
            };
            if (!this.validateUser(user)) {
                //console.log(user);
                return;
            }
            
            //this.doSignIn(user); // no callback the alert message shown.
            this.doSignIn(user, (users) => {
                this.companies = users; // setup companies array.
                this.update();
                let options = { };
                let $modal = $('#selectCustomer');
                $modal.modal(options).modal('show');
            });
        };

        this.onsubmitusercompany = (e) => {
            e.preventDefault();
            //console.log(e);
            //console.log(e.item);
            let selectedItem = e.item;
            let selectedUser = (selectedItem) ? selectedItem.company : null;
            if (selectedUser) {
                this.updateCurrentUser(selectedUser);
                this.update();
            }
            else {
                this.showAlert('No user choose.');
            }
            let $modal = $('#selectCustomer');
            let options = { };
            $modal.modal(options).modal('hide');
            this.companies = []; // clear list.
        };
    </script>
</master>