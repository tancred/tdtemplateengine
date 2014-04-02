#import "TDTemplateParser.h"
#import <PEGKit/PEGKit.h>
    
#import <TDTemplateEngine/TDTemplateContext.h>
#import "TDRootNode.h"
#import "TDVariableNode.h"
#import "TDBlockStartNode.h"
#import "TDBlockEndNode.h"
#import "TDTextNode.h"


@interface TDTemplateParser ()

@end

@implementation TDTemplateParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"template";
        self.tokenKindTab[@"block_start_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG);
        self.tokenKindTab[@"var"] = @(TDTEMPLATE_TOKEN_KIND_VAR);
        self.tokenKindTab[@"block_end_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG);
        self.tokenKindTab[@"text"] = @(TDTEMPLATE_TOKEN_KIND_TEXT);

        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG] = @"block_start_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG] = @"block_end_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_TEXT] = @"text";

    }
    return self;
}

- (void)dealloc {
        
	self.staticContext = nil;


    [super dealloc];
}

- (void)start {

    [self template_]; 
    [self matchEOF:YES]; 

}

- (void)template_ {
    
    [self execute:^{
    
	TDAssert(_staticContext);
    TDNode *root = [TDRootNode rootNodeWithStaticContext:_staticContext];
	self.assembly.target = root;
    PUSH(root);

    }];
    do {
        [self content_]; 
    } while ([self speculate:^{ [self content_]; }]);

}

- (void)content_ {
    
    if ([self predicts:TDTEMPLATE_TOKEN_KIND_VAR, 0]) {
        [self var_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG, 0]) {
        [self block_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_TEXT, 0]) {
        [self text_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'content'."];
    }

}

- (void)var_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_VAR discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
	TDNode *parent = POP();
	[parent addChild:[TDVariableNode nodeWithToken:tok]];
	PUSH(parent);

    }];

}

- (void)block_ {
    
    [self block_start_tag_]; 
    [self block_body_]; 
    [self block_end_tag_]; 

}

- (void)block_start_tag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
	TDNode *parent = POP();
	TDNode *startTagNode = [TDBlockStartNode nodeWithToken:tok];
	[parent addChild:startTagNode];
	PUSH(parent);
	PUSH(startTagNode);

    }];

}

- (void)block_end_tag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
    POP(); // startTagNode
	TDNode *parent = POP();
	TDNode *endTagNode = [TDBlockEndNode nodeWithToken:tok];
	[parent addChild:endTagNode];
	PUSH(parent);

    }];

}

- (void)block_body_ {
    
    [self content_]; 

}

- (void)text_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_TEXT discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
	TDNode *parent = POP();
	[parent addChild:[TDTextNode nodeWithToken:tok]];
	PUSH(parent);

    }];

}

@end