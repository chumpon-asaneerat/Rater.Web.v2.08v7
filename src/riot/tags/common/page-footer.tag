<page-footer class="navbar fixed-bottom m-0 p-0 navbar-light bg-primary">
    <span class="float-left m-0 p-0">
        <virtual if={(page.model && page.model.footer && page.model.footer.label)}>
            <label class="m-0 p-1">&nbsp;{page.model.footer.label.status}&nbsp;:</label>
            <div class="v-divider">&nbsp;</div>
        </virtual>
    </span>
    <span class="float-right m-0 p-0 ml-auto">
        <div class="v-divider"></div>
        <label class="m-0 p-1">
            &nbsp;
            <span id="user-info" class="fas fa-user-circle"></span>
            <virtual if={secure.current}>
                <span class="user-fullname">&nbsp; {secure.currentUserName} &nbsp;</span>
            </virtual>
        </label>
        <div class="copyright">
            <div class="v-divider"></div>
            <virtual if={(page.model && page.model.footer && page.model.footer.label)}>
                <label class="m-0 p-1">&copy;&nbsp;{page.model.footer.label.copyright}&nbsp;&nbsp;&nbsp;</label>
            </virtual>
        </div>
    </span>

    <style>
        :scope, .navbar, .nav, span {
            margin: 0 auto;
            padding: 0;
        }
        label {
            color: whitesmoke;
            font-size: 0.95em;
            font-weight: bold;
        }
        .v-divider {
            display: inline;
            margin-left: 2px;
            margin-right: 2px;
            border-left: 1px solid whitesmoke;
        }
        .copyright {
            display: inline-block;
            margin: 0 auto;
            padding: 0;
        }
        @media screen and (max-width: 800px) {
            .user-fullname {
                display: none;
            }
        }
        @media screen and (max-width: 600px) {
            .user-fullname {
                display: none;
            }
            .copyright {
                display: none;
            }
        }
    </style>
    <script>
        //-- local variables.
        let self = this;
        
        //-- setup service handlers.
        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        let onCurrentUserChanged = (sender, evtData) => { self.update(); };
        secure.currentUserChanged.add(onCurrentUserChanged);
    </script>
</page-footer>