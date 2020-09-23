({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
    // Set isModalOpen attribute to false  
    component.set("v.isModalOpen", false);
    },
})